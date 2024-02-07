import 'package:flutter/material.dart';
import 'package:gym_tracker/screens/account_screen.dart';
import 'package:gym_tracker/screens/custom_exercises_screen.dart';
import 'package:gym_tracker/screens/custom_workouts_screen.dart';
import 'package:gym_tracker/screens/settings_screen.dart';
import 'package:gym_tracker/widgets/user/user_card.dart';

class SideBar extends StatelessWidget {
  var appbarSize;
  SideBar({this.appbarSize});

  void _navTo(context, screenName) {
    Navigator.of(context).pushNamed(screenName);
  }

  Widget _buildListTile(context, title, iconData, onTapFn) {
    return ListTile(
      onTap: () => onTapFn(),
      leading: Icon(iconData),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .subhead
            .copyWith(color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _buildTopPad(context) {
    return Container(
      height: MediaQuery.of(context).padding.top + appbarSize,
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      child: Image.asset('lib/images/abstract-background.jpg', fit: BoxFit.cover,),
    );
  }

  Widget _buildUserCard(context) {
    return InkWell(
      onTap: () => showDialog(
        barrierDismissible: true,
        builder: (ctx) => AccountScreen(),
        context: context,
      ),
      child: Container(
        margin: EdgeInsets.only(left: MediaQuery.of(context).viewInsets.left),
        child: UserCard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            _buildTopPad(context),
            _buildUserCard(context),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                children: <Widget>[
                  _buildListTile(context, 'Home', Icons.home,
                      () => Navigator.of(context).pop()),
                  _buildListTile(context, 'My Exercises', Icons.library_books,
                      () => _navTo(context, CustomExercisesScreen.routeName)),
                  _buildListTile(context, 'My Workouts', Icons.assignment,
                      () => _navTo(context, CustomWorkoutsScreen.routeName)),
                  _buildListTile(context, 'Settings', Icons.settings,
                      () => _navTo(context, SettingsScreen.routeName)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
