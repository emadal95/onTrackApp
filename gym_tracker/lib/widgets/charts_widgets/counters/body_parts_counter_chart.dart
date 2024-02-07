import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/models/charts/body_par_count.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:gym_tracker/providers/exercise_sessions_provider.dart';
import 'package:provider/provider.dart';

class BodyPartsCounterChart extends StatefulWidget {
  BuildContext context;
  List<BODYPARTS> relevantParts;
  List<charts.Series<BodyPerCount, String>> data;
  DateTime dateUpperLimit;
  DateTime dateLowerLimit;

  BodyPartsCounterChart(
      {List<Exercise> exercisesData,
      BuildContext context,
      this.dateUpperLimit,
      this.dateLowerLimit}) {
    this.context = context;
    this.data = [];
    this.relevantParts = [];
    _convertDataToSeries(exercisesData);
  }

  _convertDataToSeries(exerciseData) {
    var exercisesSessions = [];
    exerciseData.forEach(
      (exercise) => exercisesSessions.addAll(
        Provider.of<ExerciseSessionsProvider>(context)
            .filterSessionsByExercise(exerciseId: exercise.id),
      ),
    );

    exercisesSessions.retainWhere(
      (session) =>
          session.workoutSession.date.isBefore(this.dateUpperLimit) &&
          session.workoutSession.date.isAfter(this.dateLowerLimit),
    );

    var bodyParts = [];
    exerciseData.forEach((exercise) => bodyParts.addAll(exercise.bodyParts));
    bodyParts = bodyParts.toSet().toList();

    Map countMap = Map.fromIterables(bodyParts, bodyParts.map((part) => 0));
    exercisesSessions.forEach((session) {
      List<BODYPARTS> sessionParts = session.exercise.bodyParts;
      sessionParts.forEach(
        (part) {
          if(part == BODYPARTS.ALL)
            countMap.keys.toList().forEach((key) => (key != BODYPARTS.ALL) ? countMap[key]++ : null);
          else if (countMap.containsKey(part)) 
            countMap[part]++;
        },
      );
    });

    countMap.removeWhere((part, count) => count <= 0);
    this.relevantParts = countMap.keys.toList().cast<BODYPARTS>();

    var dataTypeList = countMap.keys
        .map(
          (part) => BodyPerCount(
            part: part,
            count: countMap[part],
            color: HumanBody.mapToChartColor(part),
          ),
        )
        .toList();

    this.data = (exercisesSessions.length > 0)
        ? [
            charts.Series(
              id: 'Body parts count',
              data: dataTypeList,
              domainFn: (BodyPerCount bodyPerCount, _) =>
                  HumanBody.mapPartToString(bodyPerCount.part),
              measureFn: (BodyPerCount bodyPerCount, _) => bodyPerCount.count,
              colorFn: (BodyPerCount bodyPerCount, _) => bodyPerCount.color,
              labelAccessorFn: (BodyPerCount bodyPerCount, _) =>
                  '${bodyPerCount.count}',
            )
          ]
        : [];
  }

  @override
  _BodyPartsCounterChartState createState() => _BodyPartsCounterChartState();
}

class _BodyPartsCounterChartState extends State<BodyPartsCounterChart> {
  Widget _buildLegendIcon(BODYPARTS part) {
    return Animator(
      duration: Duration(seconds: 1),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (animation) => Transform.scale(
        scale: animation.value,
        child: Tooltip(
          message: HumanBody.mapPartToString(part),
          preferBelow: false,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24), color: Colors.grey),
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: HumanBody.mapToColor(part),
            ),
            child: Icon(
              HumanBody.mapToIcon(part),
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _buildLegend() {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 10,
      runSpacing: 10,
      children:
          widget.relevantParts.map((part) => _buildLegendIcon(part)).toList(),
    );
  }

  _buildPieChart() {
    return charts.PieChart(
      widget.data,
      animate: true,
      animationDuration: Duration(seconds: 1),
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 70,
        arcRendererDecorators: [
          charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.inside,
            insideLabelStyleSpec: charts.TextStyleSpec(
              fontSize: 16,
              color: charts.Color.white,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (widget.data.length > 0)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(flex: 3, child: _buildPieChart()),
              Flexible(flex: 1, child: _buildLegend())
            ],
          )
        : Container(
            child: Center(
              child: Text('No data available'),
            ),
          );
  }
}
