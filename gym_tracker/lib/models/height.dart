import 'package:flutter/material.dart';
import 'package:gym_tracker/models/utils/unit.dart';

class Height {
  static final CONVERSION_CONST = 0.393701;
  double cm = 0;
  double inch = 0;

  Height({this.cm, this.inch}){
    if(this.cm != null)
      calcInch();
    else if(this.inch != null)
      calcCm();
  }

  static Height mapToHeight(double height, UNITS unit){
    if(unit == UNITS.CM)
      return new Height(cm: height);
    else
      return new Height(inch: height);
  }

  void calcInch(){
    this.inch = cm / CONVERSION_CONST;
  }

  void calcCm(){
    this.cm = inch * CONVERSION_CONST;
  }
}