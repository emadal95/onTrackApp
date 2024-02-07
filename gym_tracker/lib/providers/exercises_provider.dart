import 'package:flutter/material.dart';
import 'package:gym_tracker/database/app_db.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:gym_tracker/models/utils/intensity.dart';
import 'package:gym_tracker/providers/exercise_sessions_provider.dart';
import 'package:provider/provider.dart';

class ExercisesProvider extends ChangeNotifier {
  List<Exercise> _exercises = [];

  setExercises(List<Exercise> exercisesList) {
    this._exercises = exercisesList;
    notifyListeners();
  }

  addExercise(Exercise newExercise) {
    if (!this._exercises.any((ex) => ex.id == newExercise.id)) {
      this._exercises.add(newExercise);
      notifyListeners();
    }
  }

  updateExercise(Exercise newEx) {
    var idx = this._exercises.indexWhere((ex) => newEx.id == ex.id);
    this._exercises[idx] = newEx;
    notifyListeners();
  }

  removeExercise(String id, BuildContext context) {
    _removeExerciseFromDb(id, context);
    this._exercises.removeWhere((ex) => ex.id == id);
    notifyListeners();
  }

  removeExerciseWithoutNotifying(String id, BuildContext context) {
    _removeExerciseFromDb(id, context);
    this._exercises.removeWhere((ex) => ex.id == id);
  }

  _removeExerciseFromDb(String exId, BuildContext context) {
    //get linked exerciseSessions
    List<String> relatedSessionsIds = Provider.of<ExerciseSessionsProvider>(context)
        .filterSessionsByExercise(exerciseId: exId)
        .map((exSes) => exSes.id)
        .toList()
        .cast<String>();
    
    Provider.of<ExerciseSessionsProvider>(context).removeExerciseSessions(sessionsIds: relatedSessionsIds, context: context); //remove linked exerciseSessions
    AppDatabase().removeExercise(exId);
  }

  updateExerciseName(String id, String newName) {
    this._exercises.firstWhere((ex) => ex.id == id).name = newName;
    notifyListeners();
  }

  updateExerciseDescription(String id, String about) {
    this._exercises.firstWhere((ex) => ex.id == id).about = about;
    notifyListeners();
  }

  updateExerciseIcon(String id, IconData icon) {
    this._exercises.firstWhere((ex) => ex.id == id).icon = icon;
    notifyListeners();
  }

  updateExerciseEquipment(String id, String equip) {
    this._exercises.firstWhere((ex) => ex.id == id).equipment = equip;
    notifyListeners();
  }

  updateExerciseBodyParts(String id, List<BODYPARTS> parts) {
    this._exercises.firstWhere((ex) => ex.id == id).bodyParts = parts;
    notifyListeners();
  }

  addExerciseBodyPart(String id, BODYPARTS part) {
    this._exercises.firstWhere((ex) => ex.id == id).bodyParts.add(part);
    notifyListeners();
  }

  updateExerciseIntensity(String id, INTENSITY_LEVEL intensity) {
    this._exercises.firstWhere((ex) => ex.id == id).level = intensity;
    notifyListeners();
  }

  List<Exercise> get exercisesList {
    return [...this._exercises];
  }

  Exercise getExerciseById(String id) {
    return this._exercises.firstWhere((ex) => ex.id == id);
  }
}
