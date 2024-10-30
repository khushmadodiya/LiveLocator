import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

double lat=0.0;
double lng= 0.0;
int _currentPosition=0;

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source,imageQuality: 30);
  if (file != null) {
    return await file.readAsBytes();
  }
}
shosnacbar(BuildContext context,String text){
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Center(child: Text(text)),)
  );

}