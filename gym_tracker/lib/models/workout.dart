import 'package:flutter/material.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/utils/weight.dart';
import 'utils/intensity.dart';

class Workout {
  String id;
  String name;
  String about;
  List<Exercise> exercises;
  IconData icon;
  INTENSITY_LEVEL level; // 1 (easy) to 5 (hard)

  Workout({
    @required this.id,
    this.name,
    this.about,
    this.exercises,
    this.level,
    this.icon
  }){
    if(exercises == null) exercises = [];
  }

  addExercise(Exercise newEx){
    this.exercises.add(newEx);
  }

  removeExercise(id){
    this.exercises.removeWhere((ex) => id == ex.id);
  }
}
