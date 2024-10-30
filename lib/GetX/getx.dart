
import 'dart:async';


import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckBool extends GetxController{
  RxBool welcomeflag = false.obs;
  RxBool homeflag = false.obs;
  RxBool homelocationflag = false.obs;

  void ChangewelcomeFlag(){
    welcomeflag.value==true?welcomeflag.value=false:welcomeflag.value=true;
  }
void ChangehomeFlag(){
    homeflag.value==true?homeflag.value=false:homeflag.value=true;
  }
void ChangehomelocationFlag(){
    homelocationflag.value==true?homelocationflag.value=false:homelocationflag.value=true;
  }

}

class GetAddress extends GetxController{

  RxString address = 'Fetching address...'.obs;
  Updateaddress(lat,lng)async{
    print('helllo');
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      Placemark place = placemarks[0];
      print(placemarks);

        address.value =
        "${place.street}, ${place.locality}, ${place
            .postalCode}, ${place.country}";
print(address.value);
    } catch (e) {
      print(e);
    }
  }
}

class MarkersForLocation extends GetxController{
  RxList<Marker> markers = <Marker>[].obs;
  void AddMarker(){
    markers.add(
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
  void UpdateMarker(double lat , double lng){
    markers[0] = Marker(
        markerId: const MarkerId('Live_Location'),
        position: LatLng(lat,lng), // Update marker position
        infoWindow: InfoWindow(
          title: 'Current Location',
          snippet: 'This is the your current location',
        )
    );
  }
}

class MapController extends GetxController {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  // Initialize the map controller when map is created
  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  // Method to animate the camera position
  Future<void> animateCameraToPosition(double latitude, double longitude) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 16, // Adjust zoom level as needed
        ),
      ),
    );
  }
}
