import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:live_location/UserApp/tracking_location_screen.dart';

class UsersList extends StatefulWidget {
  final userDoc;
  const UsersList({super.key, this.userDoc});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  bool status = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getStatus();
  }
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrackUser(
              uid: widget.userDoc['uid'],
            ),
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              tileColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              leading: widget.userDoc['photoUrl']!=''?
              CircleAvatar(
                  backgroundImage: NetworkImage(widget.userDoc['photoUrl'] )
              ):
              CircleAvatar(
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              title: Text(
                widget.userDoc['username'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              subtitle: Text(
                widget.userDoc['email'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              trailing: Row(
                children: [
                  status ? Text(
                    'Online',style: TextStyle(color: Colors.deepPurple),
                  ):
                  Text('Offline',style: TextStyle(color: Colors.red),),
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.redAccent,
                    size: 30,

                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );;
  }

  void getStatus()async {
    Map<String,dynamic> dataa;
    DataSnapshot data = await FirebaseDatabase.instance.ref().child('delivery').child(widget.userDoc['uid']).get();
    if(data.exists){
      print(data.value);
    }
  }
}
