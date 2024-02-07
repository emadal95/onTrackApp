import 'package:charts_flutter/flutter.dart' as charts;


class ExercisePerWeekDay {
  int day;
  int count;
  charts.Color color;

  ExercisePerWeekDay({this.day, this.count, this.color = charts.Color.black});
}