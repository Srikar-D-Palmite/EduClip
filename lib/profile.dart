import 'package:edu_clip/grid_view.dart';
import 'package:flutter/material.dart';

// The profile page should be expanded later on and modified. It should also be replicable so that it may be used for other people's profiles also
class ProfilePage extends StatelessWidget {
  ProfilePage({
    super.key,
  });

  // Random list of videos (to be changed later)
  final List<int> _videoIndices = List.generate(10, (index) => 10-index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                    // when pressed, remove/pop the current page. Do not run pop if there is nothing beneath the popup 
                    //   Navigator.pop(context);
                    },
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
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  const CircleAvatar(
                    radius: 50.0,
                    // to replace with user profile image
                    // backgroundImage: AssetImage('/images/avatar.png'),
                    // backgroundImage: ,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    '@johndoe',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
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
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: VideoGrid(videoIndices: _videoIndices)),
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
  }) :  _valu = value, _name = name;
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