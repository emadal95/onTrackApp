import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gym_tracker/models/charts/exercise_per_week_day.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/utils/formatter.dart';
import 'package:gym_tracker/models/utils/week.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:intl/intl.dart';

class ExercisePerWeekDayChart extends StatefulWidget {

  List data = [];
  BuildContext context;

  ExercisePerWeekDayChart({sessionData, @required this.context}) {
    data = _convertDataToSeries(sessionData);
  }

  List<charts.Series<ExercisePerWeekDay, String>> _convertDataToSeries(List<ExerciseSession> sessionsData) {
    Map<int, int> weekdayToCount = Map.fromIterables(
      Week.weekdays,
      Week.weekdays.map((day) => 0),
    );

    sessionsData.forEach(
        (session) => weekdayToCount[session.workoutSession.date.weekday]++);

    var data = weekdayToCount.keys
        .map(
          (day) => ExercisePerWeekDay(
              day: day, count: weekdayToCount[day], color: Week.weekdayColors[day]),
        )
        .toList()
        .cast<ExercisePerWeekDay>();

    return [
      new charts.Series(
        id: 'ExercisePerWeekday',
        domainFn: (exercisePerWeekDay, _) => Week.weekdayToStr(exercisePerWeekDay.day),
        measureFn: (exercisePerWeekDay, _) => exercisePerWeekDay.count,
        colorFn: (exercisePerWeekDay, __) => Week.weekdayColors[exercisePerWeekDay.day],
        labelAccessorFn: (exercisePerWeekDay, _) => '${exercisePerWeekDay.count.toString()}',
        data: data,
      ),
    ];
  }

  @override
  _ExercisePerWeekDayChartState createState() =>
      _ExercisePerWeekDayChartState();
}

class _ExercisePerWeekDayChartState extends State<ExercisePerWeekDayChart> {
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
