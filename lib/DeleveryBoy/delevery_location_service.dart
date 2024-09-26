import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_location/globle.dart';

// class LocationPage extends StatefulWidget {
//   @override
//   _LocationPageState createState() => _LocationPageState();
// }
//
// class _LocationPageState extends State<LocationPage> {
//   Position? _currentPosition;
//   String _currentAddress = 'Fetching address...';
//   StreamSubscription<Position>? _positionStreamSubscription;
//   final DatabaseReference _locationRef = FirebaseDatabase.instance.ref(
//       'delivery').child(FirebaseAuth.instance.currentUser!.uid);
//
//   @override
//   void initState() {
//     super.initState();
//
//     _startLocationTracking();
//   }
//
//
//
//   void _startLocationTracking() async {
//     try {
//       _positionStreamSubscription = Geolocator.getPositionStream(
//         locationSettings:const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 2),
//       ).listen((Position position) {
//         if (position != null) {
//          _currentPosition=position;
//           // Send location data to Firebase
//          _getAddressFromLatLng(position.latitude,position.longitude);
//           _locationRef.set({
//             'latitude': position.latitude,
//             'longitude': position.longitude,
//
//           });
//           setState(() {
//
//           });
//         } else {
//           print('No position data available');
//         }
//       });
//     } catch (e) {
//       print('Error getting location: $e');
//     }
//   }
//
//
//   @override
//   void dispose() {
//
//     super.dispose();
//     // _stopTracking();
//   }
//   void _stopTracking() {
//     _positionStreamSubscription?.cancel(); // Cancel the subscription to stop the stream
//   }
//   Future<void> _getAddressFromLatLng(double lat, double lng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
//
//       Placemark place = placemarks[0];
//
//       setState(() {
//         _currentAddress =
//         "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
//
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:const Text('Sharing Your location'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5.0),
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Sharing your location...",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
//             SizedBox(height: 20,),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.asset('assets/livegif.jpg'),
//             ),
//             SizedBox(height: 20,),
//
//             _currentPosition != null
//                 ? Text('Location: Latitude ${_currentPosition!.latitude}, Longitude ${_currentPosition!.longitude}',style: TextStyle(fontSize: 15),)
//                 : Text('Fetching location...'),
//             Text('Address:  ${
//               _currentAddress
//             }')
//           ],
//         ),
//       ),
//     );
//   }
// }

