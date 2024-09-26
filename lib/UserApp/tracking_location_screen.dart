import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map.dart';



class TrackUser extends StatelessWidget {
  final uid;
  const TrackUser({super.key, this.uid});
  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track user'),
      ),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref()
            .child('delivery')
            .child(uid)
            .onValue,
        builder: (context, snapshot) {
          if (ConnectionState.waiting == snapshot.connectionState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            print('An error occurred');
            return const Text('Some error occurred');
          }
          if (snapshot.hasData) {
            final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
            print(data);
            final lat = data!['latitude'];
            final lng = data['longitude'];
            return MapSample(
              lat: lat,
              lng: lng,
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
