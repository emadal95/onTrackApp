import 'package:charts_flutter/flutter.dart' as charts;

class TargetPerWeekday {
  int day;
  int count;
  charts.Color color;

  TargetPerWeekday({this.day, this.count, this.color = charts.Color.black});
}