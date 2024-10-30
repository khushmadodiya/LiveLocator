import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_location/UserApp/tracking_location_screen.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({super.key});

  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  @override
  Widget build(BuildContext context) {
    final controllerProvider = Provider.of<ControllerProvider>(context);
    final searchController = controllerProvider.searchUserController;

    return Scaffold(
      appBar: AppBar(
        title: Text('Track User'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  // Notify the listeners whenever the search term changes
                  controllerProvider.notifyListeners();
                },
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

                  var snap = Provider.of<AppState>(context, listen: false).snapshot;

                  // Filter users based on the search input
                  var filteredUsers = snapshot.data!.docs.where((doc) {
                    var username = doc['username'].toString().toLowerCase();
                    return username.contains(searchController.text.toLowerCase()) &&
                        doc['uid'] != snap['uid'];
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
                          // Navigate to track user screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrackUser(uid: userDoc['uid']),
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
                                leading: userDoc['photoUrl'] != ''
                                    ? CircleAvatar(
                                  backgroundImage: NetworkImage(userDoc['photoUrl']),
                                )
                                    : CircleAvatar(
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      userDoc['username'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),
                                    userDoc['status'] == 'true'
                                        ? Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        'Online',
                                        style: TextStyle(color: Colors.deepPurple),
                                      ),
                                    )
                                        : Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Text(
                                        'Offline',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  userDoc['email'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                trailing: userDoc['status'] == 'true'
                                    ? Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.deepPurple,
                                  size: 30,
                                )
                                    : Icon(
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
