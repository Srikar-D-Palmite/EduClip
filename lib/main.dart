import 'package:flutter/material.dart';

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
  static List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Text(
        'Home',
        style: TextStyle(fontSize: 30),
      ),
    ),
    Center(
      child: Text(
        'Search',
        style: TextStyle(fontSize: 30),
      ),
    ),
    Center(
      child: Text(
        'Messages',
        style: TextStyle(fontSize: 30),
      ),
    ),
    Center(
      child: Text(
        'Notifications',
        style: TextStyle(fontSize: 30),
      ),
    ),
    Center(
      child: Text(
        'Profile',
        style: TextStyle(fontSize: 30),
      ),
    ),
  ];

  // This function is called when a tab is tapped. It updates the index of the currently selected tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The scaffold provides the basic structure of the screen
    return Scaffold(
      // The body of the scaffold is the widget that corresponds to the currently selected tab
      body: _widgetOptions.elementAt(_selectedIndex),
      // The bottom navigation bar shows the available tabs
      bottomNavigationBar: BottomNavigationBar(
        // The items in the bottom navigation bar correspond to each tab
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
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