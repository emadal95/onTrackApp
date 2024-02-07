import 'package:flutter/material.dart';
import 'package:gym_tracker/models/height.dart';
import 'package:gym_tracker/models/utils/unit.dart';
import 'package:gym_tracker/models/utils/weight.dart';
import '../models/user_height.dart';
import '../models/user.dart';
import '../models/user_weigth.dart';

class UserProvider with ChangeNotifier{
  User user = new User();

  //Setters
  void setUser(User newUser){
    user = newUser;
    notifyListeners();
  }

  void setUserPreferences({weightUnit, heightUnit}){
    user.weightUnit = weightUnit;
    user.heightUnit = heightUnit;
    notifyListeners();
  }

  void setHeightUnit(unit){
    user.heightUnit = unit;
    notifyListeners();
  }

  void setWeightUnit(unit){
    user.weightUnit = unit;
    notifyListeners();
  }

  void setUserInfo({name, dob, gender, bodyType}){
    user.name = name;
    user.birthday = dob;
    user.bodyType = bodyType;
    notifyListeners();
  }

  void setBirthday(bday){
    user.birthday = bday;
    notifyListeners();
  }

  void setGender(gender){
    user.gender = gender;
    notifyListeners();
  }

  void setName(name){
    if(name.isNotEmpty)
      user.name = name;
    else
      user.name = null;
    notifyListeners();
  }

  void setImageUrl(url){
    user.image = url;
    
    notifyListeners();
  }

  void setUserWeights(List<UserWeight> userWeights){
    user.weights = userWeights;
    notifyListeners();
  }

  void addUserWeight(UserWeight newWeight){
    user.addWeight(newWeight);
    notifyListeners();
  }

  void removeUserWeight(id){
    user.removeWeight(id);
    notifyListeners();
  }

  void addWeight(double newWeight, UNITS unit, DateTime date){
    var userWeight = UserWeight(id: DateTime.now().toString(), weight: Weight.mapToWeight(newWeight, unit), date: date);
    user.addWeight(userWeight);
    notifyListeners();
  }

  void setUserHeight(UserHeight height) {
    user.height = height;
    notifyListeners();
  }

  void setHeight(double height, UNITS unit){
    user.height = UserHeight(id: UniqueKey().toString(), height: Height.mapToHeight(height, unit));
    notifyListeners();
  }

  //Getters
  String get id {
    return user.id;
  }
  String get image {
    return user.image;
  }
  String get name {
    return user.name;
  }
  List<double> get weightsList {
    return user.weights.map((weight) => (user.weightUnit == UNITS.KG) ? weight.weight.kg : weight.weight.lb).toList();
  }

  List<UserWeight> get userWeightsList {
    return [...user.weights];
  }

  UserHeight get userHeight {
    return user.height;
  }

  double get height {
    if(user.height != null)
      return (user.heightUnit == UNITS.CM) ? user.height.height.cm : user.height.height.inch;
    return null;
  }

  double get currWeight {
    Weight weight = user.weights.last.weight;
    return (user.weightUnit == UNITS.KG) ? weight.kg : weight.lb;
  }

  String get bodyType{
    return user.bodyType;
  }
  String get gender {
    return user.gender;
  }
  UNITS get weightUnit{
    return user.weightUnit;
  }
  UNITS get heightUnit {
    return user.heightUnit;
  }
  DateTime get birthday{
    return user.birthday;
  }

}