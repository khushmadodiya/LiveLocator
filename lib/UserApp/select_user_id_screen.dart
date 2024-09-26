import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_location/UserApp/tracking_location_screen.dart';
import 'package:live_location/provider/provider.dart';
import 'package:provider/provider.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({super.key});

  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  final TextEditingController controller = TextEditingController();
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        searchTerm = controller.text.toLowerCase(); // Update search term on text change
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track User'),
        // toolbarHeight: 30,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Search by username',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No users found'));
                  }

                  var snap = Provider.of<AppState>(context,listen: false).snapshot;
                  var filteredUsers = snapshot.data!.docs.where((doc) {
                    var username = doc['username'].toString().toLowerCase();
                    return username.contains(searchTerm)&& doc['uid'] !=snap['uid'];
                  }).toList();

                  if (filteredUsers.isEmpty) {
                    return Center(child: Text('No users match your search'));
                  }

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      var userDoc = filteredUsers[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrackUser(
                                uid: userDoc['uid'],
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
                                leading: CircleAvatar(
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                ),
                                title: Text(
                                  userDoc['username'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                subtitle: Text(
                                  userDoc['email'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                trailing: Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.redAccent,
                                    size: 30,

                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
