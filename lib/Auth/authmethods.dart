
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'StorageMethods.dart';
import 'user_model.dart'as model;


FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AuthMethod {
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
    await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> signup(
      {required String email,
        required String password,
        required String name,
        required Uint8List file,
        }) async {
    String res = 'some error occure';
    try {
      if (name.isNotEmpty &&
          email.isNotEmpty&&
          password.isNotEmpty &&
          file.isNotEmpty ) {
        UserCredential cred = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password));
        String photoUrl = await StorageMethods().storeprofile(file,'profile');
        model.User user = model.User(
          username: name,
          email: email,
          photoUrl: photoUrl,
          uid: cred.user!.uid,
        );

          await _firestore
              .collection('users')
              .doc(cred.user!.uid)
              .set({...user.toJson(),'status':'false'});

        res = 'success';
        return res;
      }
    } catch (e) {
      res = "some error occur : $e";
      return res;
    }
    return res;
  }
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {

      if (email.isNotEmpty && password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> signOut() async {
    String res='error';
    await _auth.signOut().onError((error, stackTrace) => res='error');
    res='success';
    return res;
  }
}
