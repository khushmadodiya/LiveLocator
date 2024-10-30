
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_location/GetX/getx.dart';
import 'package:live_location/profile.dart';
import 'package:live_location/provider/provider.dart';
import 'package:provider/provider.dart';

import 'UserApp/select_user_id_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapController mapController = Get.put(MapController());
  final MarkersForLocation markers = Get.put(MarkersForLocation());
  StreamSubscription<Position>? _positionStreamSubscription;
  final DatabaseReference _locationRef = FirebaseDatabase.instance.ref(
      'delivery').child(FirebaseAuth.instance.currentUser!.uid);

  Position?_currentPosition;
  final CheckBool flag = Get.put(CheckBool());
  final GetAddress _address = Get.put(GetAddress());

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markers.AddMarker();
    _startLocationTracking();
  }


  void _startLocationTracking() async {
    try {
      flag.ChangehomeFlag();
      Future.delayed(Duration(seconds: 5),(){flag.ChangehomelocationFlag();flag.ChangehomeFlag();});
      print(flag.homeflag.value);
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'status':'true'});
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high, distanceFilter: 2),
      ).listen((Position position) {
        if (position != null) {

          _currentPosition = position;
          _address.Updateaddress(position.latitude, position.longitude);
          _updateMarkerAndAnimateCamera();

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
    flag.ChangehomelocationFlag();
    _positionStreamSubscription
        ?.cancel();
    updateStatus();
  }
  
  void _updateMarkerAndAnimateCamera() {
    markers.UpdateMarker(_currentPosition!.latitude, _currentPosition!.longitude);
    mapController.animateCameraToPosition(_currentPosition!.latitude, _currentPosition!.longitude);
  }


  @override
  Widget build(BuildContext context) {
    var  snap =  Provider.of<AppState>(context,listen: false).snapshot;

    return WillPopScope(
      onWillPop: () async{
        updateStatus();
        return true;   },
      child: Scaffold(
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

            Obx(() {
              return Center(child: flag.homelocationflag.value ?
              Text('Sharing your Location...',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),) :
              Column(
                children: [
                  Text('Not sharing your location will',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  if(!flag.homelocationflag.value)Text('only see last location',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                ],
              ));

            }),
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
        floatingActionButton:
          FloatingActionButton(
              backgroundColor: Colors.deepPurple,
              child:Obx(
                  (){
                   return  flag.homelocationflag.value ? Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Stop', style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),),
                        Text('sharing', style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),),
                      ],
                    )) : flag.homeflag.value
                        ? Center(
                        child: CircularProgressIndicator(color: Colors.white,))
                        : Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Start', style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                        Text('sharing', style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                      ],
                    ));
                  }
              ),
              onPressed: () {
                if (flag.homelocationflag.value) {
                  _stopTracking();
                }
                else {
                  _startLocationTracking();
                }
              }

        ),
      ),
    );
  }

  Widget ShowLiveLocationMap(){
    return  Column(
      children: [
        Obx(() => Text('Address: ${_address.address.value}',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 16)))
,SizedBox(height: 7,),
        Container(
            height: MediaQuery.of(context).size.height*.49,
            child:Obx(
                (){
                  return GoogleMap(
                    markers: Set<Marker>.of(markers.markers.value),
                    mapType: MapType.hybrid,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(23.2571449,77.4898325),
                      zoom: 16,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      mapController.onMapCreated(controller);
                    },
                  );
                }
            )
        ),

      ],
    );;
  }

  void updateStatus() async{
   try{
     await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'status':'false'});

   }catch(e){
     print(e);
   }
  }


}

