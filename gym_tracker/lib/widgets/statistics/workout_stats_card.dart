import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/models/workout_session.dart';
import 'package:gym_tracker/providers/exercise_sessions_provider.dart';
import 'package:gym_tracker/providers/workout_sessions_provider.dart';
import 'package:gym_tracker/widgets/customs/card_with_header.dart';
import 'package:gym_tracker/widgets/workouts/workouts_dropdown.dart';
import 'package:provider/provider.dart';

class WorkoutStatsCard extends StatefulWidget {
  WorkoutStatsCard();

  @override
  _WorkoutStatsCardState createState() => _WorkoutStatsCardState();
}

class _WorkoutStatsCardState extends State<WorkoutStatsCard> {
  Workout _selectedWorkout;

  void _onWorkoutSelected(selectedWorkout) {
    setState(() {
      this._selectedWorkout = selectedWorkout;
    });
  }

  Widget _buildCountRow(String label, int count, {String trailing = ''}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[Text(label), Text('$count$trailing')],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .headline
          .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget get workoutDropdown {
    List<Workout> relevantWorkouts =
        Provider.of<WorkoutSessionsProvider>(context)
            .getSetOfSessionsWorkout()
            .cast<Workout>();

    this._selectedWorkout =
        (this._selectedWorkout == null && relevantWorkouts.length > 0)
            ? relevantWorkouts[0]
            : _selectedWorkout;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.centerLeft,
      child: WorkoutsDropdown(
        onWorkoutSelected: _onWorkoutSelected,
        workoutsToDisplay: relevantWorkouts,
      ),
    );
  }

  Widget get stats {
    return (relevantSessions.length > 0)
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[performedStats, timeStats],
            ),
          )
        : Container();
  }

  Widget get timeStats {
    List<Duration> times = relevantSessions
        .map((session) => Duration(milliseconds: session.durationInMillisec))
        .toSet()
        .toList();

    var maxTime = (times.length > 0)
        ? times.reduce((val, time) => Duration(
            milliseconds: max(val.inMilliseconds, time.inMilliseconds)))
        : Duration(milliseconds: 0);
    var minTime = (times.length > 0)
        ? times.reduce((val, time) => Duration(
            milliseconds: min(val.inMilliseconds, time.inMilliseconds)))
        : Duration(milliseconds: 0);
    var avgTime = (times.length > 0)
        ? Duration(
            milliseconds: (times
                        .reduce((sum, time) => Duration(
                            milliseconds:
                                sum.inMilliseconds + time.inMilliseconds))
                        .inMilliseconds /
                    times.length)
                .floor())
        : Duration(milliseconds: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Times'),
        statsDivider,
        _buildCountRow('High',
            (maxTime.inMinutes > 0) ? maxTime.inMinutes : maxTime.inSeconds,
            trailing: (maxTime.inMinutes > 0) ? ' min' : ' s'),
        _buildCountRow('Low',
            (minTime.inMinutes > 0) ? minTime.inMinutes : minTime.inSeconds,
            trailing: (minTime.inMinutes > 0) ? ' min' : ' s'),
        _buildCountRow('Average',
            (avgTime.inMinutes > 0) ? avgTime.inMinutes : avgTime.inSeconds,
            trailing: (avgTime.inMinutes > 0) ? ' min' : ' s')
      ],
    );
  }

  Widget get performedStats {
    var lastWeek = relevantSessions.where(
      (WorkoutSession session) => session.date.isAfter(
        DateTime.now().subtract(
          Duration(days: DateTime.daysPerWeek),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle('Performed'),
        statsDivider,
        _buildCountRow('Total ', relevantSessions.length),
        _buildCountRow('Last 7 Days ', lastWeek.length),
      ],
    );
  }

  Widget get statsDivider {
    return Divider(
      color: Theme.of(context).primaryColor,
      thickness: 0.5,
    );
  }

  List<WorkoutSession> get relevantSessions {
    if (_selectedWorkout == null) return [];
    return Provider.of<WorkoutSessionsProvider>(context)
        .filterSessionsByWorkout(workoutId: this._selectedWorkout.id);
  }

  @override
  Widget build(BuildContext context) {
    return CardWithHeader(
      header: workoutDropdown,
      child: stats,
      height: 300,
    );
  }
}
