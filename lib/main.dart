import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:live_location/auth_state.dart';
import 'package:live_location/home_screen.dart';
import 'package:live_location/provider/provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'globle.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>AppState())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:AuthState()
      )
    );
  }
}

class CheckLocation extends StatefulWidget{
  final uid;
  CheckLocation({
    required this.uid
});
  @override
  State<CheckLocation> createState() => _CheckLocationState();
}

class _CheckLocationState extends State<CheckLocation> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLocationPermission();
    getsnap();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Wellcome...',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 25),),
            SizedBox(height: 20,),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/map.jpg')),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
              },
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.deepPurple,
                ),
                child: Center(child: Text("Next",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),)),
              ),
            )
          ],
        ),
      ),
    );
  }

Future<void> _checkLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      print('Denied');
      _showPermissionDeniedDialog();
    } else if (permission == LocationPermission.deniedForever) {
      _showPermissionDeniedForeverDialog();
    } else {
      // getLatlng(widget.uid);
    }
  } else {

  // getLatlng(widget.uid);
  }
}

void _showPermissionDeniedDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Permission Denied'),
        content: Text('Location permission is denied. Please grant permission to use the location feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

void _showPermissionDeniedForeverDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Permission Denied Forever'),
        content: Text(
            'Location permission is permanently denied. Please enable it from the app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
  void getsnap() async{
    var uid =  FirebaseAuth.instance.currentUser!.uid;
    print(uid);
    print('hello');
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection(
          'users').doc(uid).get();
      print(snapshot['username']);
      Provider.of<AppState>(context,listen: false).snapshot=snapshot;
      print('s');
    }
    catch(e){
      print('some error occures');
    }
  }
}
void getLatlng(String uid)async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
  );
  lat=position.latitude;
  lng=position.longitude;
  FirebaseDatabase.instance.ref().child('delivery').child(uid).set({
    'latitude':lat,
    'longitude':lng
  });
  print('$lat  $lng');
}