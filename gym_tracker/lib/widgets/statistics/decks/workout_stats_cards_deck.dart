import 'package:flutter/material.dart';
import 'package:gym_tracker/widgets/customs/title_with_card.dart';
import 'package:gym_tracker/widgets/statistics/workout_stats_card.dart';

class WorkoutStatsCardsDeck extends StatefulWidget {
  WorkoutStatsCardsDeck();

  @override
  _WorkoutStatsCardsDeckState createState() => _WorkoutStatsCardsDeckState();
}

class _WorkoutStatsCardsDeckState extends State<WorkoutStatsCardsDeck> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TitleWithCard(
          WorkoutStatsCard(),
          title: 'Summary',
          subtitle: 'Counts and averages relevant to workouts',
        ),
      ],
    );
  }
}
