import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_location/Auth/text_field.dart';

class ResetPass extends StatefulWidget {


  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final TextEditingController emailcontroller = TextEditingController();

  bool flag = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Reset password'),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputText(controller: emailcontroller, hint: "Enter your Email"),
            SizedBox(height: 20,),
            FilledButton(onPressed:()async{
              flag = true;
              setState(() {

              });
             await FirebaseAuth.instance.sendPasswordResetEmail(email: emailcontroller.text.trim());
             Navigator.pop(context);
            }, child: flag?Text('Check Your email'): Text('Reset password')),

          ],
        ),
      ),
    );
  }
}
