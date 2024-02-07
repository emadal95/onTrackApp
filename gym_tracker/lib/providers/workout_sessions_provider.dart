import 'package:flutter/material.dart';
import 'package:gym_tracker/database/app_db.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/models/workout_session.dart';
import 'package:gym_tracker/providers/exercise_sessions_provider.dart';
import 'package:gym_tracker/providers/sessions_provider.dart';
import 'package:gym_tracker/providers/sets_provider.dart';
import 'package:provider/provider.dart';

class WorkoutSessionsProvider extends SessionsProvider {
  bool loadedFromDB = false;

  List<WorkoutSession> filterSessionsByWorkout({String workoutId}) {
    return sessions
        .where((session) => session.sessionWorkout.id == workoutId)
        .toList();
  }

  List<WorkoutSession> filterSessionsByDateRange(
      {DateTime from, DateTime until}) {
    until = until
        .add(Duration(days: 1)); //add one day to include 'until' into range
    return sessions
        .where((session) =>
            session.date.isAfter(from) && session.date.isBefore(until))
        .toList();
  }

  List<WorkoutSession> filterSessionsByDate(DateTime date) {
    return sessions
        .where((session) =>
            session.date.day == date.day &&
            session.date.month == date.month &&
            session.date.year == date.year)
        .toList();
  }

  List<WorkoutSession> filterSessionsByWorkoutName(String name) {
    return sessions
        .where((session) => session.sessionWorkout.name
            .toLowerCase()
            .contains(name.toLowerCase()))
        .toList();
  }

  List<WorkoutSession> filterSessionsByDateAndWorkoutName(
      Map<String, DateTime> dates, String name) {
    List<WorkoutSession> filtered = [];

    filtered = (dates['to'] == null)
        ? filterSessionsByDate(dates['from'])
        : filterSessionsByDateRange(from: dates['from'], until: dates['to']);

    filtered = filtered
        .where((session) => session.sessionWorkout.name
            .toLowerCase()
            .contains(name.toLowerCase()))
        .toList();

    return filtered;
  }

  List<ExerciseSession> getExerciseSessions({String workoutSessionId}) {
    return sessions
        .firstWhere((session) => session.id == workoutSessionId)
        .exerciseSession;
  }

  List getSetOfSessionsWorkout(){
    return sessions.map((session) => session.sessionWorkout).toSet().toList();
  }

  void removeWorkoutSessions({BuildContext context, List<String> workoutSessionIds}) {
    List<String> exerciseSessionsIds = [];
    workoutSessionIds.forEach((workoutSessionId) {
      exerciseSessionsIds.addAll(
          getSessionById(sessionId: workoutSessionId)
          .exerciseSessions
          .map((exSes) => exSes.id)
          .toList().cast<String>());
    });
    Provider.of<ExerciseSessionsProvider>(context).removeExerciseSessions(
      context: context,
      sessionsIds: exerciseSessionsIds
    ); //remove linked exercises sessions
    workoutSessionIds.forEach((sesId) {
      this.sessions.removeWhere(
          (ses) => ses.id == sesId); //remove workout sessions from Provider
      AppDatabase()
          .removeWorkoutSession(sesId); //remove workout sessions from DB
    });
    notifyListeners();
  }

  void setLoadedFromDB(loaded) {
    this.loadedFromDB = loaded;
  }

  bool get loaded {
    return loadedFromDB;
  }
}
