import 'package:flutter/material.dart';
import 'package:gym_tracker/widgets/user/settings.dart';

class SettingsScreen extends StatefulWidget {
  static final String routeName = '/settings';
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AppBar appBar = AppBar(
        title: Text('Settings'),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar,
      body: Settings(),
    
    );
  }
}
