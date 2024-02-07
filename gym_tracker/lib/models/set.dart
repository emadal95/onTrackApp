import 'package:flutter/foundation.dart';
import 'package:gym_tracker/models/set_weight.dart';

class Set {
  String id;
  String exerciseSessionId;
  SetWeight weightUsed;
  int reps;

  Set({@required this.id, @required this.exerciseSessionId, this.weightUsed, this.reps = 12});

  void setReps(int reps){
    this.reps = (reps != null) ? reps : 12;
  }

  //Static Methods:

  static List<double> generateListOfLiftingWeights({@required double start, @required double max, @required double interval}){
    List<double> liftingWeights = [];

    for (double i = start; i <= max; (i += interval)) liftingWeights.add(i);

    return liftingWeights;
  }
}