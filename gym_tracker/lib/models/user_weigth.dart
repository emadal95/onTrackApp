import 'package:flutter/foundation.dart';
import 'package:gym_tracker/models/utils/weight.dart';

class UserWeight { 
  String id;
  Weight weight;
  DateTime date;

  UserWeight({
    @required this.id,
    @required this.date,
    this.weight
  });
}
