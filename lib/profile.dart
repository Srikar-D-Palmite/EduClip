import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edu_clip/video_grid.dart';
import 'package:flutter/material.dart';

import 'settings.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

// The profile page should be expanded later on and modified. It should also be replicable so that it may be used for other people's profiles also
class _ProfilePageState extends State<ProfilePage> {
  User? user;
  late List<String> _videoKeys = [];
  late Future<QuerySnapshot<Map<String, dynamic>>> querySnapshot;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    getVideos();
  }

  void getVideos() async {
    try {
      querySnapshot = FirebaseFirestore.instance.collection("videos").get();
    } catch (e) {
      print('Error loading videos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileTopBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ProfileInfo(),
                    FutureBuilder<QuerySnapshot>(
                        future: querySnapshot,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            snapshot.data!.docs
                                .forEach((DocumentSnapshot doc) async {
                              _videoKeys.add(doc.id);
                            });
                            return VideoGrid(videoKeys: _videoKeys);
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Text('Error');
              }
              final Map<String, dynamic> data =
                  snapshot.data?.data()! as Map<String, dynamic>;
              return Text(
                "${data['firstName'] ?? 0} ${data['lastName'] ?? 0}",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
        const SizedBox(height: 15.0),
        CircleAvatar(
          radius: 50.0,
          // to replace with user profile image
          // backgroundImage: AssetImage('/images/avatar.png'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 10.0),
        FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Text('Error');
              }
              final Map<String, dynamic> data =
                  snapshot.data?.data()! as Map<String, dynamic>;
              return Text(
                "@${data['username'] ?? 0}",
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              );
            }),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            UserInfoArea(name: "Clips", value: 4),
            UserInfoArea(name: "Followers", value: 126),
            UserInfoArea(name: "Following", value: 21),
          ],
        ),
        const SizedBox(height: 20.0),
        Ink(
          decoration: BoxDecoration(border: Border.all()),
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }
}

class ProfileTopBar extends StatelessWidget {
  const ProfileTopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            "              ",
          ),
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          // more button (takes user to settings)
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class UserInfoArea extends StatelessWidget {
  const UserInfoArea({
    super.key,
    required String name,
    required int value,
  })  : _valu = value,
        _name = name;
  final String _name;
  final int _valu;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(
            _name,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          _valu.toString(),
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
