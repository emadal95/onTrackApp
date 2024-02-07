import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/models/utils/unit.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Weight {
  static final CONVERSION_CONST = 0.45359237;
  double kg;
  double lb;

  Weight({this.kg, this.lb}){
    if(this.kg != null)
      calcLb();
    else
      calcKg();
  }

  static Weight mapToWeight(double weight, UNITS unit){
    if(unit == UNITS.KG)
      return new Weight(kg: weight);
    else
      return new Weight(lb: weight);
  }

  static String mapToString(Weight weight, UNITS unit, int fixed){
    if(unit == UNITS.KG)
      return weight.kg.toStringAsFixed(fixed);
    else
      return weight.lb.toStringAsFixed(fixed);
  }

  static double getWeightInUserUnits(Weight weight, BuildContext context){
    UNITS userUnit = Provider.of<UserProvider>(context).weightUnit;
    if(userUnit == UNITS.KG)
      return weight.kg;
    return weight.lb;
  }

  void calcLb(){
    this.lb = this.kg / CONVERSION_CONST;
  }

  void calcKg(){
    this.kg = this.lb * CONVERSION_CONST;
  }
}