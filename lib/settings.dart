import 'package:flutter/material.dart';
import 'main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'General Settings',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchListTile(
            title: Text('Notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: _darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
                _toggleDarkMode(value);
              });
            },
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: Text('Change Password'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {},
          ),
        ],
      ),
    );
    
  }

  void _toggleDarkMode(bool darkModeEnabled) {
    if (darkModeEnabled) {
      // enable dark mode
      MyApp.of(context).changeTheme(ThemeMode.dark);
    } else {
      // enable light mode
      MyApp.of(context).changeTheme(ThemeMode.light);
    }
  }
}