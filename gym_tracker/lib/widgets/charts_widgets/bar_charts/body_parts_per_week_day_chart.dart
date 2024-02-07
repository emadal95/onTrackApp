import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gym_tracker/models/charts/target_per_week_day.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/utils/formatter.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:gym_tracker/models/utils/week.dart';

class BodyPartsPerWeekdayChart extends StatefulWidget {
  List data = [];
  BuildContext context;

  BodyPartsPerWeekdayChart({this.context, sessionData}) {
    this.data = _convertDataToSeries(sessionData);
  }

  _convertDataToSeries(List<ExerciseSession> sessionsData) {
    Map<int, int> weekdayToCount = Map.fromIterables(
      Week.weekdays,
      Week.weekdays.map((day) => 0),
    );

    sessionsData.forEach((session) => weekdayToCount[session.workoutSession.date.weekday]++);

    var data = weekdayToCount.keys
        .map(
          (day) => TargetPerWeekday(day: day, count: weekdayToCount[day], color: Week.weekdayColors[day]),
        )
        .toList()
        .cast<TargetPerWeekday>();

    return [
      new charts.Series(
        id: 'TargetPerWeekday',
        domainFn: (targetPerWeekday, _) => Week.weekdayToStr(targetPerWeekday.day),
        measureFn: (targetPerWeekday, _) => targetPerWeekday.count,
        colorFn: (targetPerWeekday, __) => targetPerWeekday.color,
        labelAccessorFn: (targetPerWeekday, _) => '${targetPerWeekday.count.toString()}',
        data: data,
      ),
    ];
  }

  @override
  _BodyPartsPerWeekdayChartState createState() =>
      _BodyPartsPerWeekdayChartState();
}

class _BodyPartsPerWeekdayChartState extends State<BodyPartsPerWeekdayChart> {


  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      widget.data,
      animate: true,
      animationDuration: Duration(milliseconds: 100),
      barRendererDecorator: charts.BarLabelDecorator(
        labelAnchor: charts.BarLabelAnchor.middle,
        labelPosition: charts.BarLabelPosition.outside,
        outsideLabelStyleSpec: charts.TextStyleSpec(
          fontSize: 10,
          color: charts.Color.black,
        ),
      ),
      primaryMeasureAxis: new charts.NumericAxisSpec(
        showAxisLine: false,
        renderSpec: new charts.NoneRenderSpec(),
      ),
      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          labelAnchor: charts.TickLabelAnchor.centered,
          labelJustification: charts.TickLabelJustification.inside,
          labelOffsetFromAxisPx: 10,
        ),
      ),
    );
  }
}
