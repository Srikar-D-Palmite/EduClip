import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'change_password.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _autoScrollEnabled = false;

  @override
  Widget build(BuildContext context) {
    final settings = SettingsProvider.of(context).settings;
    final updateSettings = SettingsProvider.of(context).updateSettings;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black)),
        iconTheme: IconThemeData(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
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
            title: const Text('Notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: (_darkModeEnabled =
                Theme.of(context).brightness == Brightness.dark),
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
                _toggleDarkMode(value);
              });
            },
          ),
          SwitchListTile(
            title: const Text('Autoscroll'),
            value: settings.autoScrollEnabled,
            onChanged: (bool value) {
              setState(() {
                _autoScrollEnabled = value;
                settings.autoScrollEnabled = value;
                updateSettings(settings.copyWith(autoScrollEnabled: value));
              });
            },
          ),
          const Padding(
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
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/change');
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              _logout(context);
            },
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

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}

class Settings {
  late bool notificationsEnabled;
  late bool darkModeEnabled;
  late bool autoScrollEnabled;

  Settings({
    required this.notificationsEnabled,
    required this.darkModeEnabled,
    required this.autoScrollEnabled,
  });

  Settings copyWith({
    bool? darkModeEnabled,
    bool? notificationsEnabled,
    bool? autoScrollEnabled,
  }) {
    return Settings(
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      autoScrollEnabled: autoScrollEnabled ?? this.autoScrollEnabled,
    );
  }
}

class SettingsProvider extends InheritedWidget {
  final Settings settings;
  final Function(Settings) updateSettings;

  SettingsProvider({
    Key? key,
    required Widget child,
    required this.settings,
    required this.updateSettings,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(SettingsProvider oldWidget) {
    return oldWidget.settings != settings;
  }

  static SettingsProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingsProvider>()!;
  }
}
