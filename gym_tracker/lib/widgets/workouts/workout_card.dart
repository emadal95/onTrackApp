import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/models/utils/intensity.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:path/path.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../exercises/exercises_grid.dart';

class WorkoutCard extends StatelessWidget {
  Function onCardTap;
  Workout workout;
  bool showExercises;
  double intensityCircleRadius;

  WorkoutCard(
      {this.workout,
      this.onCardTap,
      this.showExercises = true,
      this.intensityCircleRadius = 90});

  Widget _buildCardFirstRow(Workout workout, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 1, child: _buildIconCircle(workout, context)),
          SizedBox(
            width: 20,
          ),
          Expanded(flex: 2, child: _buildNameLabel(workout.name, context)),
        ],
      ),
    );
  }

  Widget _buildIconCircle(Workout workout, BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        margin: EdgeInsets.all(10),
        child: CircularPercentIndicator(
          percent: Intensity.mapToIntensityPercentage(workout.level),
          radius: intensityCircleRadius,
          animation: true,
          animationDuration: 2000,
          lineWidth: 4,
          progressColor: Intensity.mapToColor(workout.level),
          center: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
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
        minFontSize: 12,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.title.copyWith(fontSize: 25),
      ),
    );
  }

  Widget _buildWorkoutAbout(String about, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: AutoSizeText(
        (about != null && about.isNotEmpty)
            ? about
            : 'No description available',
        minFontSize: 16,
        maxFontSize: 16,
        style: Theme.of(context).textTheme.caption.copyWith(
            color: (about != null && about.isNotEmpty) ? Colors.black : null),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildWorkoutCardContent(Workout workout, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardFirstRow(workout, context),
          ...sectionDivider,
          _buildWorkoutAbout(workout.about, context),
          ...sectionDivider,
          if (workout.exercises.length > 0 && showExercises) ExercisesGrid(workout.exercises)
        ],
      ),
    );
  }

  List<Widget> get sectionDivider {
    return [
      Divider(),
      SizedBox(height: 6),
    ];
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
