import 'package:flutter/material.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/set_weight.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:gym_tracker/models/utils/intensity.dart';
import 'package:gym_tracker/models/utils/unit.dart';
import 'package:gym_tracker/models/utils/weight.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/models/workout_session.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import '../models/set.dart';
import 'package:intl/intl.dart';

class QueryHelper {

  static Map<String, Object> toQueryUserData(UserProvider user){
    return {
      'id': user.id,
      'name': user.name,
      'height': user.height,
      'body': user.bodyType,
      'gender': user.gender,
      'birthday': (user.birthday != null) ? user.birthday.toIso8601String() : null,
      'image': user.image
    };
  }

  static Map<String, Object> toQueryWeightData(double weight, UNITS unit, DateTime date){
    var w = Weight.mapToWeight(weight, unit);
    return {
      'id': UniqueKey().toString(),
      'kg': w.kg,
      'lb': w.lb,
      'date': date.toIso8601String()
    };
  }

  static Map<String, Object> toQueryWorkoutData(Workout workout){
    return {
      'id': workout.id,
      'name': workout.name,
      'about': workout.about,
      'icon_code': '${workout.icon.fontFamily}:${workout.icon.codePoint.toRadixString(16)}',
      'intensity': Intensity.mapToString(workout.level),
      'exercises': Exercise.mapListToString(workout.exercises)
    };
  }

  static Map<String, Object> toQueryExerciseData(Exercise exercise) {
    return {
      'id': exercise.id,
      'name': exercise.name,
      'equipment': exercise.equipment,
      'icon_code': '${exercise.icon.fontFamily}:${exercise.icon.codePoint.toRadixString(16)}', //icon saved as string <fontFamily>:<codePoint>
      'intensity': Intensity.mapToString(exercise.level),
      'body_parts': HumanBody.mapPartsListToString(exercise.bodyParts),
      'about': exercise.about
    };
  }

  static Map<String, Object> toQueryWorkoutSessionData(WorkoutSession session){
      return {
        'id': session.id,
        'millisecs_duration': session.durationInMillisec,
        'date': (session.date != null) ? session.date.toIso8601String() : null,
        'session_workout_id': session.sessionWorkout.id
      };
  }

  static Map<String, Object> toQueryExerciseSessionData(ExerciseSession session){
      return {
        'id': session.id,
        'workout_id': session.workoutSession.id,
        'exercise_id': session.exercise.id,
        'millisecs_duration': session.durationInMillisec,
        'note': session.note
      };
  }

  static Map<String, Object> toQuerySetData(Set _set){
    return {
      'id': _set.id,
      'exercise_session_id': _set.exerciseSessionId,
      'weight_id': (_set.weightUsed != null) ? _set.weightUsed.id : null,
      'reps': _set.reps
    };
  }

  static Map<String, Object> toQuerySetWeightData(SetWeight weight){
    return {
      'id': weight.id,
      'lb': weight.weight.lb,
      'kg': weight.weight.kg
    };
  }
}