
import 'package:flutter/material.dart';
import 'package:gym_tracker/database/app_db.dart';
import 'package:gym_tracker/database/query_helper.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/utils/intensity.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/providers/workout_sessions_provider.dart';
import 'package:provider/provider.dart';

class WorkoutsProvider with ChangeNotifier{
  List<Workout> _workouts = [];

  setWorkouts(List<Workout> workouts){
    this._workouts = workouts;
    notifyListeners();
  }

  addWorkout(Workout workout){
    if(!this._workouts.any((w) => w.id == workout.id)){
      this._workouts.add(workout);
      notifyListeners();
    }
  }

  addWorkoutWithoutNotifying(Workout workout){
    if(!this._workouts.any((w) => w.id == workout.id))
      this._workouts.add(workout);
  }

  removeWorkout(String id, @required BuildContext context){
    _removeWorkoutFromDb(id, context);
    this._workouts.removeWhere((workout) => id == workout.id);
    notifyListeners();
  }

  removeWorkoutWithoutNotifying(String id, @required BuildContext context){
    _removeWorkoutFromDb(id, context);
    this._workouts.removeWhere((workout) => id == workout.id);
  }

  _removeWorkoutFromDb(String id, BuildContext context){
     //get linked workoutSessions
    List<String> relatedSessionsIds = Provider.of<WorkoutSessionsProvider>(context)
        .filterSessionsByWorkout(workoutId: id)
        .map((workoutSes) => workoutSes.id)
        .toList()
        .cast<String>();
    
    Provider.of<WorkoutSessionsProvider>(context).removeWorkoutSessions(workoutSessionIds: relatedSessionsIds, context: context); //remove linked workoutSessions
    AppDatabase().removeWorkout(id);
  }

  updateWorkout(String id, Workout updated){
    var idx = this._workouts.indexWhere((workout) => id == workout.id);
    this._workouts[idx] = updated;
    notifyListeners();
  }

  updateWorkoutName(String workoutId, String name){
    this._workouts.firstWhere((workout) => workout.id == workoutId).name = name;
    notifyListeners();
  }

  updateWorkoutDescription(String workoutId, String about){
    this._workouts.firstWhere((workout) => workout.id == workoutId).about = about;
    notifyListeners();
  }

  updateWorkoutIcon(String workoutId, IconData icon){
    this._workouts.firstWhere((workout) => workout.id == workoutId).icon = icon;
    notifyListeners();
  }

  updateWorkoutLevel(String workoutId, INTENSITY_LEVEL level){
    this._workouts.firstWhere((workout) => workout.id == workoutId).level = level;
    notifyListeners();
  }

  addExerciseToWorkout(String workoutId, Exercise newExercise){
    this._workouts.firstWhere((workout) => workout.id == workoutId).addExercise(newExercise);
    print(this._workouts.firstWhere((workout) => workout.id == workoutId).exercises);
    notifyListeners();
  }

  Workout getWorkoutById(String id){
    return this._workouts.firstWhere((workout) => id == workout.id);
  }

  List<Workout> get workoutsList {
    return [..._workouts];
  }
}