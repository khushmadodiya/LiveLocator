import 'dart:async';
import 'package:flutter/cupertino.dart';
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

  @override
  void initState() {
    super.initState();
    _addMarker();
  }

  @override
  void didUpdateWidget(MapSample oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lat != widget.lat || oldWidget.lng != widget.lng) {
      _updateMarker();
      _animateToLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: Set<Marker>.of(_markers),
      mapType: MapType.hybrid,
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.lat, widget.lng),
        zoom: 16,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
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
}