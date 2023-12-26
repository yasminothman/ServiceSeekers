import 'package:flutter/material.dart';
import 'dark_mode.dart';
import 'setting.dart'; // Import the setting.dart file

class CustomDrawer extends StatefulWidget {
  final Function(bool) updateThemeMode;

  CustomDrawer({required this.updateThemeMode});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isDarkModeEnabled = DarkMode.isDarkModeEnabled;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SafeArea(
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Welcome',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push( // Navigate to the SettingPage
                context,
                MaterialPageRoute(
                  builder: (context) => SettingPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: _isDarkModeEnabled ? Icon(Icons.nights_stay) : Icon(Icons.wb_sunny),
            title: _isDarkModeEnabled ? Text('Dark Mode') : Text('Light Mode'),
            trailing: Switch(
              value: _isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _isDarkModeEnabled = value;
                  DarkMode.toggleDarkMode(value);
                  widget.updateThemeMode(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
