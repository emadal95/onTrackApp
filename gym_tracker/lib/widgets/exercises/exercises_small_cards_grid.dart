import 'package:flutter/material.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/models/workout_session.dart';
import 'package:gym_tracker/screens/exercises_sessions_loop.dart';
import 'package:gym_tracker/widgets/exercises/exercise_small_card.dart';

class ExerciseSmallCardsGrid extends StatefulWidget {
  Workout parentWorkout;
  WorkoutSession workoutSession;
  Function onExerciseSessionCompleted;
  List<String> pickedExercisesIds;
  final Color primaryColor;

  ExerciseSmallCardsGrid({this.parentWorkout, @required this.workoutSession, this.onExerciseSessionCompleted, this.pickedExercisesIds, this.primaryColor});

  @override
  _ExerciseSmallCardsGridState createState() => _ExerciseSmallCardsGridState();
}

class _ExerciseSmallCardsGridState extends State<ExerciseSmallCardsGrid> {
  BuildContext context;

  void _onExercisePicked(Exercise exercise){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ExerciseSessionLoop(exercise: exercise, color: widget.primaryColor, workoutSession: widget.workoutSession, onCompleted: widget.onExerciseSessionCompleted,),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _onExercisePicked(exercise),
      child: ExerciseSmallCard(exercise: exercise, highlighted: (widget.pickedExercisesIds.contains(exercise.id)) ? true : false,),
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return GridView.builder(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(20),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (ctx, i) => _buildExerciseCard(widget.parentWorkout.exercises[i]),
      itemCount: widget.parentWorkout.exercises.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }
}
