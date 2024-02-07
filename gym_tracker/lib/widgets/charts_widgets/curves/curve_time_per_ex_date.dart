import 'package:flutter/material.dart';
import 'package:gym_tracker/models/charts/time_per_exercise_date.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/utils/formatter.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:intl/intl.dart';

class TimePerExerciseDateChart extends StatefulWidget {
  List data = [];
  BuildContext context;
  bool inSeconds;
  
  TimePerExerciseDateChart({sessionData, @required this.context, @required this.inSeconds}) {
    data = _convertDataToSeries(sessionData);
  }

  List<charts.Series<TimePerDate, DateTime>> _convertDataToSeries(sessionsData) {
    sessionsData.sort((ExerciseSession a, ExerciseSession b) =>
        a.workoutSession.date.compareTo(b.workoutSession.date));

    var data = sessionsData.map(
      (session) => TimePerDate(
        date: session.workoutSession.date,
        duration: Duration(milliseconds: session.durationInMillisec),
      ),
    ).toList().cast<TimePerDate>();

    return [
      new charts.Series(
        id: 'TimeProgress',
        domainFn: (timePerDate, _) => timePerDate.date,
        measureFn: (timePerDate, _) => (inSeconds) ? timePerDate.duration.inSeconds : timePerDate.duration.inMinutes,
        data: data,
        colorFn: (_, __) => BODYPARTCOLORS.bordeaux,
      ),
    ];
  }

  @override
  _TimePerExerciseDateChartState createState() =>
      _TimePerExerciseDateChartState();
}

class _TimePerExerciseDateChartState extends State<TimePerExerciseDateChart> {
  
  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: charts.TimeSeriesChart(
        widget.data,
        defaultRenderer: new charts.LineRendererConfig(includeArea: true, includePoints: true, radiusPx: 1, areaOpacity: 0.1),
        animate: true,
        animationDuration: Duration(milliseconds: 100),
        behaviors: [
          charts.PanAndZoomBehavior(panningCompletedCallback: () {}),
        ],
        primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
              zeroBound: true, desiredTickCount: 6),
          showAxisLine: false,
          tickFormatterSpec:
              charts.BasicNumericTickFormatterSpec.fromNumberFormat(NumberFormat('#### ${(widget.inSeconds) ? 's' : 'min'}')),
          renderSpec: new charts.GridlineRendererSpec(
            labelAnchor: charts.TickLabelAnchor.centered,
            labelJustification: charts.TickLabelJustification.inside,
          ),
        ),
        domainAxis: new charts.DateTimeAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
            labelAnchor: charts.TickLabelAnchor.centered,
            labelJustification: charts.TickLabelJustification.inside,
            labelOffsetFromAxisPx: 10,
          ),
          tickFormatterSpec: Formatter.datetimeLineGraphTickFormatter
        ),
      ),
    );
  }
}
