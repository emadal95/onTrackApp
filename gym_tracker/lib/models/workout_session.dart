import "package:flutter/foundation.dart";
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/workout.dart';

class WorkoutSession {
  String id;
  DateTime date;
  int durationInMillisec;
  Workout sessionWorkout;
  List<ExerciseSession> exerciseSessions;

  WorkoutSession({
    @required this.id,
    @required this.sessionWorkout,
    this.date,
    this.durationInMillisec,
    this.exerciseSessions
  }){
    if(exerciseSessions == null) exerciseSessions = [];
  }

  void setWorkout(Workout newWorkout){
    this.sessionWorkout = newWorkout;
  }

  void addExerciseSession(ExerciseSession newExerciseSession){
    this.exerciseSessions.add(newExerciseSession);
  }

  void setDuration(int duration){
    this.durationInMillisec = duration;
  }
}
