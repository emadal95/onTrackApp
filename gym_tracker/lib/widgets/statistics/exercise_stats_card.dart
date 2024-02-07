import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/utils/unit.dart';
import 'package:gym_tracker/models/utils/weight.dart';
import 'package:gym_tracker/providers/exercise_sessions_provider.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:gym_tracker/widgets/customs/card_with_header.dart';
import 'package:gym_tracker/widgets/exercises/exercises_dropdown.dart';
import 'package:provider/provider.dart';

class ExerciseStatsCard extends StatefulWidget {
  ExerciseStatsCard();

  @override
  _ExerciseStatsCardState createState() => _ExerciseStatsCardState();
}

class _ExerciseStatsCardState extends State<ExerciseStatsCard> {
  Exercise _selectedExercise;
  String weightUnitStr;

  void _onExerciseSelected(Exercise newEx) {
    setState(() {
      this._selectedExercise = newEx;
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

  Widget _buildSubsectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .subhead
          .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Widget get exercisePicker {
    List<Exercise> relevantExercises =
        Provider.of<ExerciseSessionsProvider>(context)
            .getSetOfSessionsExercise()
            .cast<Exercise>();

    this._selectedExercise =
        (this._selectedExercise == null && relevantExercises.length > 0)
            ? relevantExercises[0]
            : _selectedExercise;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.centerLeft,
      child: ExercisesDropdown(
        onExerciseSelected: _onExerciseSelected,
        exercisesToDisplay: relevantExercises,
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
              children: <Widget>[performanceStats, averageStats, extremesStats],
            ),
          )
        : Container();
  }

  Widget get extremesStats {
    List<double> weights = [];
    relevantSessions.forEach(
      (session) => session.sets
          .where((_set) => _set.weightUsed != null)
          .forEach(
            (_set) => weights.add(
                Weight.getWeightInUserUnits(_set.weightUsed.weight, context)),
          ),
    );

    List<Duration> times = relevantSessions
        .where((ExerciseSession session) =>
            session.durationInMillisec != null &&
            session.durationInMillisec > 0)
        .map((session) => Duration(milliseconds: session.durationInMillisec))
        .toList();

    var maxTime = (times.length > 0)
        ? times.reduce((val, time) => Duration(
            milliseconds: max(val.inMilliseconds, time.inMilliseconds)))
        : Duration(seconds: 0);
    var minTime = (times.length > 0)
        ? times.reduce((val, time) => Duration(
            milliseconds: min(val.inMilliseconds, time.inMilliseconds)))
        : Duration(milliseconds: 0);
    
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildSectionTitle('Extremes'),
          statsDivider,
          _buildSubsectionTitle('Max'),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: _buildCountRow(
              'Weight ',
              weights.reduce((a, b) => max(a, b)).floor(),
              trailing: ' $weightUnitStr',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: _buildCountRow('Time ',
                (maxTime.inMinutes > 0) ? maxTime.inMinutes : maxTime.inSeconds,
                trailing: (maxTime.inMinutes > 0) ? ' min' : ' s'),
          ),
          _buildSubsectionTitle('Min'),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: _buildCountRow(
              'Weight ',
              weights.reduce((a, b) => min(a, b)).floor(),
              trailing: ' $weightUnitStr',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: _buildCountRow('Time ',
                (minTime.inMinutes > 0) ? minTime.inMinutes : minTime.inSeconds,
                trailing: (minTime.inMinutes > 0) ? ' min' : ' s'),
          ),
        ],
      ),
    );
  }

  Widget get averageStats {
    List<int> setsPerSession = relevantSessions
        .map((session) => session.sets.length)
        .toList()
        .cast<int>();
    var repsPerSet = relevantSessions
        .map((session) => session.sets)
        .map((setList) => setList.map((_set) => _set.reps));

    var repsSum = 0;
    var recordedReps = 0;
    repsPerSet.forEach(
      (repsList) => repsList.forEach((rep) {
        repsSum += rep;
        recordedReps += 1;
      }),
    );

    var weights = relevantSessions
        .map((session) {
          var weights = session.sets
              .where((_set) => _set.weightUsed != null)
              .map((_set) =>
                  Weight.getWeightInUserUnits(_set.weightUsed.weight, context))
              .toList();

          double weightsAvg = (weights.length > 0)
              ? weights.reduce((sum, weight) => sum + weight) / weights.length
              : 0;

          return weightsAvg.floor();
        })
        .toList()
        .cast<int>();

    weights.removeWhere((weightAvg) => weightAvg == 0);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildSectionTitle('Average'),
          statsDivider,
          _buildCountRow(
              'Sets ',
              (setsPerSession.reduce((int sum, int val) => sum + val) /
                      setsPerSession.length)
                  .floor()),
          _buildCountRow('Reps ', (repsSum / recordedReps).floor()),
          _buildCountRow(
            'Lifting Weight ',
            (weights.reduce((int sum, weight) => sum + weight) / weights.length).floor(),
            trailing: ' $weightUnitStr'
          ),
        ],
      ),
    );
  }

  Widget get performanceStats {
    var lastWeek = relevantSessions.where(
      (ExerciseSession session) => session.workoutSession.date.isAfter(
        DateTime.now().subtract(
          Duration(days: DateTime.daysPerWeek),
        ),
      ),
    );

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildSectionTitle('Performed'),
          statsDivider,
          _buildCountRow('Total ', relevantSessions.length),
          _buildCountRow('Last 7 Days ', lastWeek.length),
        ],
      ),
    );
  }

  Widget get statsDivider {
    return Divider(
      color: Theme.of(context).primaryColor,
      thickness: 0.5,
    );
  }

  List<ExerciseSession> get relevantSessions {
    if (_selectedExercise == null) return [];
    return Provider.of<ExerciseSessionsProvider>(context)
        .filterSessionsByExercise(exerciseId: this._selectedExercise.id);
  }

  @override
  Widget build(BuildContext context) {
    weightUnitStr = Unit.mapToStr(Provider.of<UserProvider>(context).weightUnit);
    return CardWithHeader(
      header: exercisePicker,
      child: stats,
      height: 500,
    );
  }
}
