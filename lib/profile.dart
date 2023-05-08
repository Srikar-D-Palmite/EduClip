import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edu_clip/grid_view.dart';
import 'package:flutter/material.dart';

import 'settings.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

// The profile page should be expanded later on and modified. It should also be replicable so that it may be used for other people's profiles also
class _ProfilePageState extends State<ProfilePage> {
  // ProfilePage({
  //   super.key,
  // });
  User? user;

  // Random list of videos (to be changed later)
  final List<String> _videoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://media.istockphoto.com/id/1449673113/video/drone-view-of-van-point-brittany-france.mp4?s=mp4-640x640-is&k=20&c=YSIrsLs9VdrGDbazjN74UMtKMXggD_x3VBgj7Lt-jpE=',
    'https://media.istockphoto.com/id/1435810600/video/hand-choosing-smile-face-from-emotion-block-customer-review-good-experience-positive-feedback.mp4?s=mp4-640x640-is&k=20&c=6qpiKhW8PxrvX5Me9dQSZUaveVFhVYatIWAN-PvlEG0=',
    'https://media.istockphoto.com/id/1410075891/video/aerial-shot-of-the-verdon-gorge-in-provence-france.mp4?s=mp4-640x640-is&k=20&c=BJ8P1a-NpK_4hNKA5qQ8YtRLg22DxMuoFSayvSFeEyk=',
    'https://media.istockphoto.com/id/1380176517/video/picturesque-white-mountain-slopes-covered-with-pine-forests-and-skiing-pistes-and-moving.mp4?s=mp4-640x640-is&k=20&c=nq_sMpw-d103WEDzM2LSLkxLIpRa7sGeL2dcL2RFd3w=',
    'https://media.istockphoto.com/id/1410582936/video/flamingo.mp4?s=mp4-640x640-is&k=20&c=z77sqHUh6JF-_BZiTzUolBz0uNITJjEPfxbv95cRqC4=',

    // 'https://flutter.github.io/assets-for-api-docs/assets/videos/rooster.mp4',
  ];
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                ],
              ),
            ),
            Expanded(child: VideoGrid(videoUrls: _videoUrls)),
          ],
        ),
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
