
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_location/Auth/authmethods.dart';
import 'package:live_location/DeleveryBoy/delevery_location_service.dart';
import 'package:live_location/profile.dart';
import 'package:live_location/provider/provider.dart';
import 'package:provider/provider.dart';

import 'UserApp/select_user_id_screen.dart';
import 'UserApp/tracking_location_screen.dart';

Position? _currentPostion;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer<
      GoogleMapController>();
  List<Marker> _markers = [];

  String _currentAddress = 'Fetching address...';
  StreamSubscription<Position>? _positionStreamSubscription;
  final DatabaseReference _locationRef = FirebaseDatabase.instance.ref(
      'delivery').child(FirebaseAuth.instance.currentUser!.uid);

  bool flag = false;
  bool location= false;
  Position?_currentPosition;

  @override
  void initState() {
    super.initState();
    // FlutterForegroundService().start();
    AddMarker();
    _startLocationTracking();
  }


  void _startLocationTracking() async {
    try {
      setState(() {
        flag = true;
      });
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high, distanceFilter: 2),
      ).listen((Position position) {
        if (position != null) {

          _currentPosition = position;
          // Send location data to Firebase
          _getAddressFromLatLng(position.latitude, position.longitude);
          setState(() {
            location = true;
            flag =false;
            _updateMarker();
            _animateToLocation();
          });

          _locationRef.set({
            'latitude': position.latitude,
            'longitude': position.longitude,

          });

        } else {
          print('No position data available');
        }
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }


  @override
  void dispose() {
    super.dispose();
    // _stopTracking();
  }

  void _stopTracking() {
    setState(() {
      location = false;
    });
    _positionStreamSubscription
        ?.cancel(); // Cancel the subscription to stop the stream
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
        "${place.street}, ${place.locality}, ${place
            .postalCode}, ${place.country}";

      });
    } catch (e) {
      print(e);
    }
  }


  void AddMarker() {
    _markers.add(
        Marker(
            markerId: MarkerId('Live_Location'),
            position:LatLng(23.2571449,77.4898325),
            infoWindow: InfoWindow(
              title: 'Current Location',
              snippet: 'This is the your current location',
            )
        )

    );
  }
  void _updateMarker() {
    setState(() {
      _markers[0] = Marker(
          markerId: const MarkerId('Live_Location'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude), // Update marker position
          infoWindow: InfoWindow(
            title: 'Current Location',
            snippet: 'This is the your current location',
          )
      );
    });
  }

  Future<void> _animateToLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 16,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var  snap =  Provider.of<AppState>(context,listen: false).snapshot;

    return Scaffold(
      appBar: AppBar(
        title: Text("Livelocator"),
       actions:[
         InkWell(
           onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen())),
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 10.0),
             child:snap['photoUrl']!=null?CircleAvatar(
               radius: 20,
               backgroundImage: NetworkImage(snap['photoUrl']),
             ): CircleAvatar(
               radius: 17,
               child: Icon(Icons.person,size: 30,),
             ),
           ),
         )
       ]
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Center(child:location?
          Text('Sharing your Location...',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),):
          Text('Not sharing your location will',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
          if(!location)Text('only see last location',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          ShowLiveLocationMap(),
          SizedBox(height: 10,),
          InkWell(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>SelectUser()));

            },
            child: Column(
              children: [
                const  Text('Track Location',style: TextStyle(fontSize: 20),),
                Card(
                  elevation: 8,
                  child: Container(
                    height: MediaQuery.of(context).size.height*.2,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/tracklocation.jpg')),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),

      floatingActionButton:FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: location ? Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Stop',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
            Text('sharing',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
          ],
        )) : flag ? Center(child: CircularProgressIndicator(color: Colors.white,)):Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Start',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white)),
            Text('sharing',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white)),
          ],
        )),
        onPressed: () {
          setState(() {
            if(location){
              _stopTracking();
            }
            else{
              _startLocationTracking();
            }

          });

        },


      ),
    );
  }

  Widget ShowLiveLocationMap(){
    return  Column(
      children: [
        _currentPosition==null ? Center(child: CircularProgressIndicator(),):Text('Address: $_currentAddress',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 16),)
,SizedBox(height: 7,),
        Container(
            height: MediaQuery.of(context).size.height*.45,
            child: GoogleMap(
              markers: Set<Marker>.of(_markers),
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: LatLng(23.2571449,77.4898325),
                zoom: 16,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            )
        ),

      ],
    );;
  }


}

