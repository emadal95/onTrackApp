import 'package:flutter/material.dart';
import 'package:gym_tracker/database/app_db.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/workout_session.dart';
import 'package:gym_tracker/providers/sessions_provider.dart';
import 'package:gym_tracker/providers/sets_provider.dart';
import 'package:provider/provider.dart';
import '../models/set.dart';

class ExerciseSessionsProvider extends SessionsProvider {
  removeExerciseSessions(
      {List<String> sessionsIds, @required BuildContext context}) {
    List<String> setIdsToDel = [];
    sessionsIds.forEach((sesId) {
      //get linked Sets ids
      setIdsToDel.addAll(Provider.of<SetsProvider>(context)
          .filterByExerciseSession(sessionId: sesId)
          .map((_set) => _set.id)
          .toList()
          .cast<String>());
    });

    Provider.of<SetsProvider>(context)
        .removeSets(setIds: setIdsToDel); //delete linked Sets
    sessions.removeWhere((session) => sessionsIds
        .contains(session.id)); //delete Exercise Sessions from provider
    sessionsIds.forEach((sessionId) => AppDatabase()
        .removeExerciseSession(sessionId)); //delete Exercise Sessions from DB
    notifyListeners();
  }

  setExerciseSessionSets({String sessionId, List<Set> sets}) {
    sessions.firstWhere((session) => session.id == sessionId).sets = sets;
    notifyListeners();
  }

  setWorkoutSession({String workoutSessionId, WorkoutSession workoutSession}) {
    sessions
        .where(
            (exerciseSes) => exerciseSes.workoutSessionId == workoutSessionId)
        .toList()
        .forEach(
          (exerciseSes) => exerciseSes.workoutSession = workoutSession,
        );
    notifyListeners();
  }

  filterSessionsByWorkoutSession({String workoutSessionId}) {
    return sessions
        .where((session) => session.workoutSessionId == workoutSessionId)
        .toList();
  }

  filterSessionsByExercise({String exerciseId}) {
    return sessions
        .where((session) => session.exercise.id == exerciseId)
        .toList();
  }

  getSessionsWithBodyPartsOnly(){
    return sessions.where((session) => session.exercise.bodyParts.length > 0).toList();
  }

  getExerciseOfSessionsWithWeightOnly() {
    var exercises = [];
    sessions.forEach(
      (session) => session.sets.any((_set) =>
              _set.weightUsed != null &&
              !exercises.any((ex) => ex.id == session.exercise.id))
          ? exercises.add(session.exercise)
          : null,
    );

    return exercises;
  }

  getExerciseOfSessionsWithBodyPartsOnly() {
    return sessions
        .where((session) => session.exercise.bodyParts.length > 0)
        .map((session) => session.exercise)
        .toSet()
        .toList();
  }

  getExerciseOfSessionsWithTimeOnly() {
    return sessions
        .where((session) =>
            session.durationInMillisec != null &&
            session.durationInMillisec > 0)
        .map((session) => session.exercise)
        .toSet()
        .toList();
  }

  getWeightOnlySessionsWithExerciseId({String exerciseId}) {
    List relevantSessions =
        sessions.where((session) => session.exercise.id == exerciseId).toList();
    relevantSessions = relevantSessions
        .where((session) => session.sets.any((_set) => _set.weightUsed != null))
        .toList();
    return relevantSessions;
  }

  getTimeOnlySessionsWithExerciseId({String exerciseId}) {
    return sessions
        .where(
          (session) =>
              (session.exercise.id == exerciseId) &&
              (session.durationInMillisec != null &&
                  session.durationInMillisec > 0.0),
        )
        .toList();
  }

  getSessionSets({String exerciseSessionId}) {
    return sessions
        .firstWhere((session) => session.id == exerciseSessionId)
        .sets;
  }

  getSetOfSessionsExercise(){
    return sessions.map((session) => session.exercise).toSet().toList();
  }
}
