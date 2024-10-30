import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../globle.dart';

class MapSample extends StatefulWidget {
  final double lat;
  final double lng;

  const MapSample({super.key, required this.lat, required this.lng});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  List<Marker> _markers = [];
  String _currentAddress = '';

  @override
  void initState() {
    super.initState();
    _addMarker();
    _getAddressFromLatLng(widget.lat, widget.lng);

  }

  @override
  void didUpdateWidget(MapSample oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lat != widget.lat || oldWidget.lng != widget.lng) {
      _updateMarker();
      _animateToLocation();
      _getAddressFromLatLng(widget.lat, widget.lng);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Address : ${_currentAddress}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        SizedBox(height: 10,),
        Expanded(
          child: GoogleMap(
            markers: Set<Marker>.of(_markers),
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.lat, widget.lng),
              zoom: 16,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
      ],
    );
  }
  void _addMarker()async {
    // final BitmapDescriptor customIcon = await BitmapDescriptor.asset(
    //   const ImageConfiguration(size: Size(40, 40)),
    //   'assets/tracklocation.jpg', // Path to your custom marker image
    // );
    _markers.add(
      Marker(
        markerId: const MarkerId('user_marker'),
        position: LatLng(widget.lat, widget.lng),
        infoWindow: const InfoWindow(
          title: 'User Location',
          snippet: 'This is the user\'s current location',
        ),
      ),
    );
    _markers.add(
      Marker(
        // icon: customIcon,
        markerId: const MarkerId('You'),
        position: LatLng(lat as double,lng as double),
        infoWindow: const InfoWindow(
          title: 'Current Location',
          snippet: 'This is current location',
        ),
      ),
    );
    setState(() {});
  }

  void _updateMarker() {
    setState(() {
      _markers[0] = Marker(
        markerId: const MarkerId('user_marker'),
        position: LatLng(widget.lat, widget.lng), // Update marker position
        infoWindow: const InfoWindow(
          title: 'User Location',
          snippet: 'Updated location',
        ),
      );
    });
  }

  Future<void> _animateToLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(widget.lat, widget.lng),
          zoom: 16,
        ),
      ),
    );
  }
  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      Placemark place = placemarks[0];
      print(placemarks);
      setState(() {
        _currentAddress =
        "${place.street}, ${place.locality}, ${place
            .postalCode}, ${place.country}";
      });
    print(_currentAddress);
    print('hellllllllllooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
    } catch (e) {
      print(e);
    }
  }
}