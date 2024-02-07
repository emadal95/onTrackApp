import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BodyPerCount {
  BODYPARTS part;
  int count;
  charts.Color color;

  BodyPerCount({this.part, this.count, this.color});
}