import 'package:gym_tracker/database/app_db.dart';

import '../models/set.dart';
import 'package:flutter/cupertino.dart';

class SetsProvider extends ChangeNotifier {
  List<Set> _sets = [];

  setSets({List<Set> sets}) {
    this._sets = sets;
    notifyListeners();
  }

  filterByExerciseSession({String sessionId}) {
    return this
        ._sets
        .where((_set) => _set.exerciseSessionId == sessionId)
        .toList();
  }

  void addSet({Set newSet}) {
    this._sets.add(newSet);
    notifyListeners();
  }

  void removeSets({List<String> setIds}) {
    setIds.forEach((setId) {
      if(byId(setId: setId).weightUsed != null) AppDatabase().removeSetWeight(byId(setId: setId).weightUsed.id); //remove linked weight if any
   
      this._sets.removeWhere((_set) => _set.id == setId); // remove set from provider
      AppDatabase().removeSet(setId); //remove set from db
    }); 

    notifyListeners();
  }

  List<Set> get setsList {
    return [...this._sets];
  }

  Set byId({setId}) {
    return this._sets.firstWhere((_set) => _set.id == setId);
  }
}
