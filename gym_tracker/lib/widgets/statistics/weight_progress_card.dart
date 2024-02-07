import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/tools_icons.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/providers/exercise_sessions_provider.dart';
import 'package:gym_tracker/providers/exercises_provider.dart';
import 'package:gym_tracker/widgets/charts_widgets/curves/curve_weight_avg_per_ex_date.dart';
import 'package:gym_tracker/widgets/customs/card_with_header.dart';
import 'package:gym_tracker/widgets/customs/primary_color_divider.dart';
import 'package:gym_tracker/widgets/exercises/exercises_dropdown.dart';
import 'package:provider/provider.dart';

class WeightProgressCard extends StatefulWidget {
  WeightProgressCard();

  @override
  _WeightProgressCardState createState() => _WeightProgressCardState();
}

class _WeightProgressCardState extends State<WeightProgressCard> {
  Exercise _selectedExercise;

  onExerciseSelected(selection) {
    setState(() {
      _selectedExercise = selection;
    });
  }

  Widget get cardHeader {
    List<Exercise> relevantExercises = Provider.of<ExerciseSessionsProvider>(context).getExerciseOfSessionsWithWeightOnly().cast<Exercise>();
    if (_selectedExercise == null && relevantExercises.length > 0) _selectedExercise = relevantExercises[0];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6,),
      alignment: Alignment.centerLeft,
      child: ExercisesDropdown(onExerciseSelected: onExerciseSelected, exercisesToDisplay: relevantExercises,)//exercisesDropdown,
    );
  }

  Widget get graph {
    return Container(
      //color: Colors.blue,
      width: double.infinity,
      alignment: Alignment.center,
      child: WeightPerExerciseDateChart(context: context, sessionsData: relevantSessions,),
    );
  }

  List<ExerciseSession> get relevantSessions {
    if(_selectedExercise == null) return [];
    return Provider.of<ExerciseSessionsProvider>(context).getWeightOnlySessionsWithExerciseId(exerciseId: _selectedExercise.id).cast<ExerciseSession>();
  }

  @override
  Widget build(BuildContext context) {
    return CardWithHeader(
      height: 300,
      header: cardHeader,
      child: graph,
    );
  }
}
