import 'package:flutter/material.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/providers/exercise_sessions_provider.dart';
import 'package:gym_tracker/widgets/charts_widgets/bar_charts/exercise_per_week_day_chart.dart';
import 'package:gym_tracker/widgets/customs/card_with_header.dart';
import 'package:gym_tracker/widgets/exercises/exercises_dropdown.dart';
import 'package:gym_tracker/widgets/exercises/exercises_picker.dart';
import 'package:provider/provider.dart';

class ExerciseWeekDaysDistributionCard extends StatefulWidget {
  ExerciseWeekDaysDistributionCard();

  @override
  _ExerciseWeekDaysDistributionCardState createState() =>
      _ExerciseWeekDaysDistributionCardState();
}

class _ExerciseWeekDaysDistributionCardState
    extends State<ExerciseWeekDaysDistributionCard> {
  Exercise _selectedExercise;

  void _onExerciseSelected(Exercise selection) {
    setState(() {
      this._selectedExercise = selection;
    });
  }

  Widget get exercisePicker {
    var relevantExercises = Provider.of<ExerciseSessionsProvider>(context)
        .getSetOfSessionsExercise()
        .cast<Exercise>();
    if (relevantExercises.length > 0 && _selectedExercise == null)
      _selectedExercise = relevantExercises[0];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 6,
      ),
      alignment: Alignment.centerLeft,
      child: ExercisesDropdown(
        onExerciseSelected: _onExerciseSelected,
        exercisesToDisplay: relevantExercises,
      ),
    );
  }

  Widget get graph {
    return Container(
      //color: Colors.blue,
      width: double.infinity,
      alignment: Alignment.center,
      child: ExercisePerWeekDayChart(
        context: context,
        sessionData: relevantSessions,
      ),
    );
  }

  List<ExerciseSession> get relevantSessions {
    if(_selectedExercise == null) return [];
    return Provider.of<ExerciseSessionsProvider>(context).filterSessionsByExercise(exerciseId: _selectedExercise.id).cast<ExerciseSession>();
  }

  @override
  Widget build(BuildContext context) {
    return CardWithHeader(
      header: exercisePicker,
      child: graph,
      height: 300,
    );
  }
}
