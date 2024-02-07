import 'package:flutter/material.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/providers/exercise_sessions_provider.dart';
import 'package:gym_tracker/widgets/charts_widgets/counters/body_parts_counter_chart.dart';
import 'package:gym_tracker/widgets/customs/card_with_header.dart';
import 'package:gym_tracker/widgets/customs/time_interval_picker.dart';
import 'package:provider/provider.dart';

class BodyPartsFocusCard extends StatefulWidget {
  BodyPartsFocusCard();

  @override
  _BodyPartsFocusCardState createState() => _BodyPartsFocusCardState();
}

class _BodyPartsFocusCardState extends State<BodyPartsFocusCard> {
  Duration duration;
  String measure;
  String dur;

  @override
  void initState() { 
    super.initState();
    duration = Duration(days: 365); //set to 1 year
    measure = 'Years';
    dur = '1';
  }
  

  _onDurationUpdated(String newDuration){
    setState(() {
      dur = newDuration;
      int d = int.parse(newDuration);
      duration = _buildDuration(d, measure);
    });
  }

  _onMeasurementUpdated(String newMeasure){
    setState(() {
      measure = newMeasure;
      duration = _buildDuration(int.parse(dur), newMeasure);
    });
  }

  Duration _buildDuration(d, m){
    var factor = 1;
    switch(m){
      case 'Years':
        factor = 365;
        break;
      case 'Months':
        factor = 30;
        break;
      case 'Weeks':
        factor = 7;
        break;
      default:
        factor = 1;
    }

    return Duration(days: factor * d);
  }

  Widget get intervalPicker {

    return TimeIntervalPicker(
      onDurationChange: _onDurationUpdated,
      onMeasurementChanged: _onMeasurementUpdated,
      leadingText: 'Show last ',
    );

  }

  Widget get graph {
    
    var relevantExercises = Provider.of<ExerciseSessionsProvider>(context)
        .getExerciseOfSessionsWithBodyPartsOnly()
        .cast<Exercise>();
    if (relevantExercises == null) relevantExercises = [];
    
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: BodyPartsCounterChart(
        context: context,
        exercisesData: relevantExercises,
        dateUpperLimit: DateTime.now(),
        dateLowerLimit: DateTime.now().subtract(this.duration)
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return CardWithHeader(
      header: intervalPicker,
      child: graph,
      height: 400,
    );

  }
}
