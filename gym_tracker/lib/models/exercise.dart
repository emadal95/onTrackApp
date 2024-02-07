import 'package:flutter/material.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:gym_tracker/models/utils/intensity.dart';
import 'package:gym_tracker/providers/exercises_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class Exercise {
  String id;
  String name;
  IconData icon;
  String about;
  String equipment;
  INTENSITY_LEVEL level;
  List<BODYPARTS> bodyParts = [];

  Exercise({
    @required this.id,
    @required this.icon,
    this.name,
    this.bodyParts,
    this.about,
    this.equipment,
    this.level,
  }) {
    if (bodyParts == null) bodyParts = [];
  }

  static List<Exercise> mapListFromString(String dbStr, BuildContext context) {
    List<Exercise> exercises = [];

    if (dbStr == null || dbStr.isEmpty) return exercises;

    dbStr.split(',').forEach(
      (id) => (Provider.of<ExercisesProvider>(context).exercisesList.any((ex) => ex.id == id)) ? exercises.add(
        Provider.of<ExercisesProvider>(context).getExerciseById(id),
      ): null
    );

    return exercises;
  }

  static String mapListToString(List<Exercise> exercises){
    String exercisesStr = "";

    if(exercises == null)
      return exercisesStr;
    int i=0;
    exercises.forEach((exercise){
      exercisesStr = '${exercisesStr}${exercise.id}';
      if(i != exercises.length-1)
        exercisesStr = '${exercisesStr},';
      i++;
    });

    return exercisesStr;
  }
}
