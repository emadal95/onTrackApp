import 'package:flutter/material.dart';
import 'package:gym_tracker/database/app_db.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:gym_tracker/widgets/statistics/decks/statistics_cards_deck.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  UserProvider user;

  _buildBody(user) {
    this.user = user;
    return StatisticsCardsDeck();
  }

  @override
  Widget build(BuildContext context) {
    print('building stats');
    return (user == null)
        ? FutureBuilder(
            future: AppDatabase().loadSavedData(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData && snapshot.data['sessions']['workoutSessions'].loaded)
                return _buildBody(snapshot.data['user']);
              else
                return Center(child: CircularProgressIndicator());
            },
          )
        : _buildBody(user);
  }
}
