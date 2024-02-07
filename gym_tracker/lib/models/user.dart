import 'package:gym_tracker/models/utils/unit.dart';
import 'package:gym_tracker/models/user_height.dart';
import 'user_weigth.dart';

class User {
  String id;
  String name;
  List<UserWeight> weights;
  UserHeight height;
  String bodyType;
  String gender;
  UNITS weightUnit;
  UNITS heightUnit;
  DateTime birthday;
  String image;

  User({
    this.id,
    this.name,
    this.height,
    this.birthday,
    this.bodyType,
    this.weights,
    this.gender,
    this.heightUnit = UNITS.INCH,
    this.weightUnit = UNITS.LB,
    this.image
  }){
    if(heightUnit == null) heightUnit = UNITS.INCH;
    if(weightUnit == null) weightUnit = UNITS.LB;
    weights = [];
  }

  addWeight(UserWeight w){
    weights.add(w);
  }

  removeWeight(String id){
    weights.removeWhere((entry) => entry.id == id);
  }
}
