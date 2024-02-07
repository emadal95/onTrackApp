import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/chart_icons.dart';
import 'package:gym_tracker/screens/stats_screen.dart';
import 'package:gym_tracker/screens/new_session_screen.dart';
import 'package:gym_tracker/screens/sessions_screen.dart';
import 'package:gym_tracker/widgets/customs/sidebar.dart';

class TabScreen extends StatefulWidget {
  TabScreen();

  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  Widget _buildTabItem(IconData icon, String title) {
    return Tab(
      icon: Icon(
        icon,
        size: 20.0,
      ),
    );
  }

  AppBar _buildAppBar(){
    return AppBar(
          title: Text('iWorkout'),
          textTheme: Theme.of(context).appBarTheme.textTheme,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 5.0,
            indicatorColor: Theme.of(context).accentColor,
            labelColor: Colors.white,
            tabs: <Widget>[
              _buildTabItem(ChartIcons.chart_bar_4, 'Stats'),
              _buildTabItem(ChartIcons.tasks, 'Sessions'),
              _buildTabItem(Icons.alarm_add, 'Timer'),
            ],
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    var appBar = _buildAppBar();

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: appBar,
        drawer: SideBar(appbarSize: appBar.preferredSize.height,),
        body: TabBarView(
          children: <Widget>[StatsScreen(), SessionsScreen(), NewSessionScreen()],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
  }
}
