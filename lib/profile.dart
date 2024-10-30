import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_location/Auth/login_screen.dart';
import 'package:live_location/provider/provider.dart';
import 'package:provider/provider.dart';

import 'Auth/authmethods.dart';






class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 var  snap =  Provider.of<AppState>(context,listen: false).snapshot;
    _usernameController.text = snap['username'];
    _emailController.text = snap['email'];
  }
  @override
  void dispose(
      ) {
    super.dispose();
    _emailController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var  snap =  Provider.of<AppState>(context,listen: false).snapshot;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.deepPurple,
        title: Text('Profile',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.w600
        ),),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > 600
              ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ClipRRect(borderRadius:BorderRadius.circular(10),child: Image.network(snap['photoUrl'])),
              const SizedBox(
                height: 10,
              ),
            if(snap['photoUrl']!=null)
                CircleAvatar(
              radius: 100,

              backgroundImage: NetworkImage(snap['photoUrl']),
            )
                else CircleAvatar(
                radius: 64,
                backgroundColor: Colors.deepPurple[50],
                child: Icon(Icons.person,size: 110,)),
              SizedBox(height: 20,),

              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter username',
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                  filled: true,
                  contentPadding: const EdgeInsets.all(8),
                ),
                controller: _usernameController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextField(

                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                  filled: true,
                  contentPadding: const EdgeInsets.all(8),
                ),
                controller: _emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: ()async{
                  try{
                    await  FirebaseDatabase.instance.ref().child(FirebaseAuth.instance.currentUser!.uid).update({'status':false});
                    AuthMethod().signOut();
                  }
                  catch(e){
                    Fluttertoast.showToast(msg: "some error occure");
                  }


                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);

                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: Colors.deepPurple,
                  ),
                  child: !_isLoading
                      ? const Text(
                    'Logout',style: TextStyle(fontSize: 20,color: Colors.white),
                  )
                      : const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }



}
