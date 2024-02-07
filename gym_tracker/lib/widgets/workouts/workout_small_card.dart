import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:gym_tracker/models/utils/intensity.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/widgets/body_parts/body_part_simple_icon.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WorkoutSmallCard extends StatelessWidget {
  Function onCardTap;
  Workout workout;
  bool showExercises;
  double intensityCircleRadius;

  WorkoutSmallCard(
      {this.workout,
      this.onCardTap,
      this.showExercises = true,
      this.intensityCircleRadius = 90});

  getListOfBodyPartsFromExercisesList(List<Exercise> exercises) {
    List<BODYPARTS> parts = [];
    exercises.forEach(
      (ex) => ex.bodyParts.forEach((part) {
        if (!parts.contains(part)) parts.add(part);
      }),
    );
    return parts;
  }

  Widget _buildCardFirstRow(Workout workout, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(flex: 1, child: _buildIconCircle(workout, context)),
        SizedBox(
          width: 10,
        ),
        Expanded(flex: 2, child: _buildNameLabel(workout.name, context)),
      ],
    );
  }

  Widget _buildIconCircle(Workout workout, BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        margin: EdgeInsets.all(0),
        child: CircularPercentIndicator(
          percent: Intensity.mapToIntensityPercentage(workout.level),
          radius: intensityCircleRadius,
          animation: true,
          animationDuration: 2000,
          lineWidth: 5,
          progressColor: Intensity.mapToColor(workout.level),
          center: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 40,
              child: Icon(
                IconData(workout.icon.codePoint,
                    fontFamily: workout.icon.fontFamily),
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameLabel(String name, BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 80,
      child: AutoSizeText(
        name,
        maxLines: 1,
        maxFontSize: 25,
        minFontSize: 18,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.title.copyWith(fontSize: 25),
      ),
    );
  }

  Widget _buildWorkoutAbout(String about, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: AutoSizeText(
        about,
        minFontSize: 12,
        maxFontSize: 14,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.caption.copyWith(
              color: (about != null && about.isNotEmpty) ? Colors.black : null,
            ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildBodyPartsSummary(
      List<Exercise> exercises, BuildContext context) {
    List<BODYPARTS> bodyParts = getListOfBodyPartsFromExercisesList(exercises);

    return Container(
      width: double.infinity,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 2,
        runSpacing: 0,
        alignment: WrapAlignment.start,
        children: bodyParts
            .map((part) => Chip(
                  avatar: BodyPartSimpleIcon(part: part, size: 12),
                  label: AutoSizeText(HumanBody.mapPartToString(part), minFontSize:10, maxFontSize: 10,),
                  labelStyle:Theme.of(context).textTheme.body2.copyWith(fontSize: 8),
                  backgroundColor: Theme.of(context).chipTheme.disabledColor,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildWorkoutCardContent(Workout workout, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, right: 20, left: 20, top: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(flex: 1, child: _buildCardFirstRow(workout, context)),
          if (workout.about != null && (workout.about.isNotEmpty && MediaQuery.of(context).size.width >= 380) || workout.exercises.length > 0)
            Divider(),
          if (workout.about != null && workout.about.isNotEmpty && MediaQuery.of(context).size.width >= 380)
            Flexible(flex: 2, child: _buildWorkoutAbout(workout.about, context)),
          //Divider(),
          if (workout.exercises.length > 0)
            Expanded(
              flex: 4,
              child: _buildBodyPartsSummary(workout.exercises, context),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () => onCardTap(workoutId: workout.id),
      child: Card(
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: _buildWorkoutCardContent(workout, context)),
    );
  }
}
