import 'package:flutter/material.dart';
import 'dart:math';

// This is the main entry point for the application
void main() => runApp(MyApp());

// This widget is the root of the application
class MyApp extends StatelessWidget  {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The title of the application
      title: 'Educlip',
      // The color theme of the application
      theme: ThemeData(
        primaryColor: Colors.black,
        // accentColor: Colors.white,
      ),
      // The initial screen of the application
      home: MyHomePage(title: 'Educlip'),
    );
  }
}

// This widget represents the home screen of the application
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// This widget represents the state of the home screen of the application
class _MyHomePageState extends State<MyHomePage> {
  // The index of the currently selected tab
  int _selectedIndex = 0;

  // The widgets that correspond to each tab
  static final List<Widget> _widgetOptions = <Widget>[
    const Center(
      child: Text(
        'Home',
        style: TextStyle(fontSize: 30),
      ),
    ),
    const Center(
      child: Text(
        'Explore',
        style: TextStyle(fontSize: 30),
      ),
    ),
    const Center(
      child: Text(
        'Messages',
        style: TextStyle(fontSize: 30),
      ),
    ),
    const Center(
      child: Text(
        'Notifications',
        style: TextStyle(fontSize: 30),
      ),
    ),
    const Center(
      child: Text(
        'Profile',
        style: TextStyle(fontSize: 30),
      ),
    ),
  ];

  // Random list of videos (to be changed later)
  final List<int> _videoIndices = List.generate(50, (index) => Random().nextInt(100));

  // This function is called when a tab is tapped. It updates the index of the currently selected tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildVideoGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      // The number of videos to display
      itemCount: _videoIndices.length,
      // The layout of the grid
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.47,
      ),
      // The widgets to display in the grid
      itemBuilder: (BuildContext context, int index) {
        // Return a blank video widget with a random number indicating the video index
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: Text(
              'Video ${_videoIndices[index]}',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // The scaffold provides the basic structure of the screen
    return Scaffold(
      appBar: null, // hide the app bar
      // The body of the scaffold is the widget that corresponds to the currently selected tab
      body: _selectedIndex == 1 ? _buildVideoGrid() : _widgetOptions.elementAt(_selectedIndex),
      // The bottom navigation bar shows the available tabs
      bottomNavigationBar: BottomNavigationBar(
        // The items in the bottom navigation bar correspond to each tab
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        // The index of the currently selected tab
        currentIndex: _selectedIndex,
        // The color of the icon of the currently selected tab
        selectedItemColor: Colors.black,
        // The color of the icon of the unselected tabs
        unselectedItemColor: Colors.grey,
        // The background color of the bottom navigation bar
        // backgroundColor: Colors.black,
        // This function is called when a tab is tapped
        onTap: _onItemTapped,
      ),
    );
  }
}