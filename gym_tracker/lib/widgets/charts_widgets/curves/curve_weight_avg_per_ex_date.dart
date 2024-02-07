import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gym_tracker/models/charts/weight_avg_per_exercise_date.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/utils/formatter.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:gym_tracker/models/utils/unit.dart';
import 'package:gym_tracker/models/utils/weight.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeightPerExerciseDateChart extends StatefulWidget {
  List data = [];
  BuildContext context;

  WeightPerExerciseDateChart({sessionsData, this.context}) {
    data = _convertDataToSeries(sessionsData);
  }

  List<charts.Series<WeightAvgPerExerciseDate, DateTime>> _convertDataToSeries(
      sessionsData) {
    sessionsData.sort((ExerciseSession a, ExerciseSession b) =>
        a.workoutSession.date.compareTo(b.workoutSession.date));
    var data = sessionsData
        .map((session) {
          var weights = session.sets
              .where((_set) => _set.weightUsed != null)
              .toList()
              .map((_set) =>
                  Weight.getWeightInUserUnits(_set.weightUsed.weight, context))
              .toList();
          double weightsAvg =
              weights.reduce((sum, weight) => sum + weight) / weights.length;

          return new WeightAvgPerExerciseDate(
              weightAvg: weightsAvg.floor(), date: session.workoutSession.date);
        })
        .toList()
        .cast<WeightAvgPerExerciseDate>();

    return [
      new charts.Series(
        id: 'WeightProgress',
        domainFn: (weightAvgPerExerciseDate, _) => weightAvgPerExerciseDate.date,
        measureFn: (weightAvgPerExerciseDate, _) => weightAvgPerExerciseDate.weightAvg,
        colorFn: (_, __) => BODYPARTCOLORS.blue,
        labelAccessorFn: (weightAvgPerExerciseDate, _) => '${weightAvgPerExerciseDate.weightAvg}',
        data: data,
      ),
    ];
  }

  @override
  _WeightPerExerciseDateChartState createState() =>
      _WeightPerExerciseDateChartState();
}

class _WeightPerExerciseDateChartState
    extends State<WeightPerExerciseDateChart> {
  _WeightPerExerciseDateChartState();


  @override
  Widget build(BuildContext context) {
    String weightUnit =
        Unit.mapToStr(Provider.of<UserProvider>(context).weightUnit);
    
    return Container(
      child: charts.TimeSeriesChart(
        widget.data,
        defaultRenderer: charts.LineRendererConfig(includeArea: true, includePoints: true, radiusPx: 1, areaOpacity: 0.1,),
        animate: true,
        animationDuration: Duration(milliseconds: 100),
        behaviors: [
          charts.PanAndZoomBehavior(panningCompletedCallback: () {}),
        ],
        primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
              zeroBound: false, desiredTickCount: 4),
          showAxisLine: false,
          tickFormatterSpec:
              charts.BasicNumericTickFormatterSpec.fromNumberFormat(NumberFormat('#### $weightUnit')),
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
