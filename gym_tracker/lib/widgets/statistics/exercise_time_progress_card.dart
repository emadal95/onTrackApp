import 'package:flutter/material.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/providers/exercise_sessions_provider.dart';
import 'package:gym_tracker/widgets/charts_widgets/curves/curve_time_per_ex_date.dart';
import 'package:gym_tracker/widgets/customs/card_with_header.dart';
import 'package:gym_tracker/widgets/customs/time_unit_chips.dart';
import 'package:gym_tracker/widgets/exercises/exercises_dropdown.dart';
import 'package:provider/provider.dart';

class ExerciseTimeProgressCard extends StatefulWidget {
  ExerciseTimeProgressCard();

  @override
  _ExerciseTimeProgressCardState createState() =>
      _ExerciseTimeProgressCardState();
}

class _ExerciseTimeProgressCardState extends State<ExerciseTimeProgressCard> {
  Exercise _selectedExercise;
  TIMEUNITS timeUnit;

  @override
  void initState() {
    super.initState();
    this.timeUnit = TIMEUNITS.seconds;
  }

  void _onExerciseSelected(Exercise exerciseSelected) {
    setState(() {
      this._selectedExercise = exerciseSelected;
    });
  }

  void _onTimeUnitSelected(TIMEUNITS newUnit){
    setState(() {
      this.timeUnit = newUnit;
    });
  }

  Widget get header {
    var relevantExercises = Provider.of<ExerciseSessionsProvider>(context)
        .getExerciseOfSessionsWithTimeOnly()
        .cast<Exercise>();
    if (relevantExercises.length > 0 && _selectedExercise == null)
      _selectedExercise = relevantExercises[0];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 5,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6,
            ),
            alignment: Alignment.centerLeft,
            child: ExercisesDropdown(
              onExerciseSelected: _onExerciseSelected,
              exercisesToDisplay: relevantExercises,
            ),
          ),
        ),
        SizedBox(width: 20,),
        Flexible(
          flex: 2,
          child: TimeUnitChips(onUnitSelected: _onTimeUnitSelected, initialSelection: this.timeUnit,),
        )
      ],
    );
  }

  Widget get graph {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: TimePerExerciseDateChart(
        sessionData: relevantSessions,
        context: context,
        inSeconds: (this.timeUnit == TIMEUNITS.seconds) ? true : false,
      ),
    );
  }

  List<ExerciseSession> get relevantSessions {
    if (_selectedExercise == null) return [];
    return Provider.of<ExerciseSessionsProvider>(context)
        .getTimeOnlySessionsWithExerciseId(exerciseId: _selectedExercise.id)
        .cast<ExerciseSession>();
  }

  @override
  Widget build(BuildContext context) {
    return CardWithHeader(
      header: header,
      child: graph,
      height: 300,
    );
  }
}
