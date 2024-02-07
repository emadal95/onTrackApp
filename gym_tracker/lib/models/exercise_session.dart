import 'package:flutter/foundation.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/workout_session.dart';
import './set.dart';

class ExerciseSession {
  String id;
  WorkoutSession workoutSession;
  String workoutSessionId;
  List<Set> sets;
  int durationInMillisec; 
  Exercise exercise;
  String note;

  ExerciseSession({
    @required this.id,
    @required this.workoutSessionId,
    this.workoutSession,
    @required this.exercise,
    this.sets,
    this.durationInMillisec,
    this.note
  }){
    if(sets == null) sets = [];
  }

  void setSets(List<Set> sets){
    this.sets = sets;
  }

  void setWorkoutSession(WorkoutSession session){
    this.workoutSession = session;
  }
}
