import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_location/home_screen.dart';
import 'package:live_location/main.dart';

import 'Auth/login_screen.dart';

class AuthState extends StatelessWidget {
  const AuthState({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              var uid = FirebaseAuth.instance.currentUser!.uid;
              return CheckLocation(uid:uid );
            } else if (snapshot.hasError) {
              return Center(child: Text('An error occurred'));
            }
          }

          if (snapshot.connectionState == ConnectionState.waiting ) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return LoginScreen();
        },
      ),
    );
  }
}
