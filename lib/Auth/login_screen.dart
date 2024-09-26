
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:live_location/Auth/reset_pass.dart';
import 'package:live_location/Auth/signup_screen.dart';
import 'package:live_location/Auth/text_field.dart';
import 'package:live_location/main.dart';

import '../globle.dart';
import '../home_screen.dart';
import 'authmethods.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();

  bool flag = false;
  @override
  Widget build(BuildContext context) {
    final Width=MediaQuery.of(context).size.width;
    final Height=MediaQuery.of(context).size.height;
    login()async{
      setState(() {
        flag = true;
      });

      String res = await AuthMethod().loginUser(email: emailcontroller.text.trim(), password: passcontroller.text.trim());
      setState(() {
        flag = false;
      });
      if(res=='success'){
        try{
          String doc=FirebaseAuth.instance.currentUser!.uid.toString();
          print(doc);
          var snap= await FirebaseFirestore.instance.collection('users').doc(doc).get();
          // Provider.of<AppState>(context, listen: false).firstSnapshot = snap;
          print(snap['email']);
          shosnacbar(context, res);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckLocation(uid: snap['uid'])));
        }
        catch(e){
          res='Some error occurs';
          shosnacbar(context, res);// AuthMethod().signOut();
        }


      }
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    }

    return GestureDetector(
      onTap: (){ FocusScope.of(context).unfocus();},
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: Width > 600
                ? EdgeInsets.symmetric(
                horizontal: Width / 2.9)
                : const EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 90,),
                  Text("LiveLocator",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                  SizedBox(height: 10,),
                  Container(height:190,child: ClipRRect(borderRadius:BorderRadius.circular(10),child: Image.asset('assets/map.jpg'))),
                  SizedBox(height: 20,),
                  InputText(controller: emailcontroller, hint: "Enter your Email"),
                  SizedBox(height: 20,),
                  InputText(controller: passcontroller, hint:'Enter password',ispass: true,isform: true,),
                  SizedBox(height: 25,),
                  FilledButton(onPressed:login, child: flag?CircularProgressIndicator(color: Colors.white,): Text('  Log in  ')),
                  SizedBox(height: 10,),
                  TextButton(onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPass()));
                  }, child:const Text('Forget password')),
                  SizedBox(height: 10,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Do not have accunt '),
                        InkWell(
                          child: Text('Regiter',style: TextStyle(color: Colors.deepPurple),),
                          onTap: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                          },
                        )
                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
