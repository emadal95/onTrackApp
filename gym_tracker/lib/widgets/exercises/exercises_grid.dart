import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/chart_icons.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:gym_tracker/models/utils/intensity.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class ExercisesGrid extends StatelessWidget {
  List<Exercise> exercises;

  ExercisesGrid(this.exercises);

  Widget _buildBodyPartCircle(BODYPARTS bodyPart, BuildContext context) {
    return CircularPercentIndicator(
      radius: 28,
      percent: 1,
      lineWidth: 2,
      progressColor: Theme.of(context).accentColor,
      animation: true,
      animationDuration: 1000,
      center: Icon(
        HumanBody.mapToIcon(bodyPart),
        size: 18,
      ),
    );
  }

  Widget _buildIntensityCircle(level) {
    return CircularPercentIndicator(
      radius: 28,
      percent: Intensity.mapToIntensityPercentage(level),
      progressColor: Intensity.mapToColor(level),
      animation: true,
      animationDuration: 2500,
      lineWidth: 2,
      center: Icon(ChartIcons.chart_bar_2, size: 18),
    );
  }

  Widget _buildExerciseSpecsGrid(
      List<BODYPARTS> bodyParts, INTENSITY_LEVEL level, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 6,
        children: <Widget>[
          _buildIntensityCircle(level),
          ...bodyParts
              .map((part) => _buildBodyPartCircle(part, context))
              .toList(),
        ],
      ),
    );
  }

  Widget _builExerciseCard(Exercise exercise, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              exercise.name,
              maxLines: 1,
              maxFontSize: 16,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: Colors.black),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          _buildExerciseSpecsGrid(exercise.bodyParts, exercise.level, context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (exercises != null && exercises.length > 0)
        ? GridView.builder(
            physics: ScrollPhysics(), // to disable GridView's scrolling
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            scrollDirection: Axis.vertical,
            itemBuilder: (ctx, i) => _builExerciseCard(exercises[i], context),
            itemCount: exercises.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 1.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 0,
            ),
          )
        : AutoSizeText(
            'No exercises have been added yet',
            minFontSize: 16,
            maxFontSize: 16,
            style: Theme.of(context).textTheme.caption,
          );
  }
}
