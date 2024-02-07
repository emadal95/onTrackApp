import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/providers/workouts_provider.dart';
import 'package:gym_tracker/widgets/workouts/workout_small_card.dart';
import 'package:provider/provider.dart';

class WorkoutsGrid extends StatefulWidget {
  Color borderColor;
  Function onWorkoutSelected;
  WorkoutsGrid({this.borderColor, this.onWorkoutSelected});

  _WorkoutsGridState createState() => _WorkoutsGridState();
}

class _WorkoutsGridState extends State<WorkoutsGrid> {
  WorkoutsProvider workouts;
  String workoutId;

  void _onWorkoutSelected({String workoutId}) {
    widget.onWorkoutSelected(workoutId: workoutId);
    setState(() {
      this.workoutId = workoutId;
    });
  }

  Widget _buildWorkoutCard(Workout workout) {
    return WorkoutSmallCard(
      workout: workout,
      onCardTap: _onWorkoutSelected,
      showExercises: false,
      intensityCircleRadius: 82,
    );
  }

  Widget get noDataWidget {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: AutoSizeText(
            'You haven\'t created any custom workouts yet.',
            textAlign: TextAlign.center,
          ),
        ),
        Center(
          child: AutoSizeText(
            'In the side bar, navigate to \'My Workouts\' to add custom workouts.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    workouts = Provider.of<WorkoutsProvider>(context);
    MediaQueryData query = MediaQuery.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      height: ((query.orientation == Orientation.portrait)
              ? (query.size.height - query.viewInsets.top - query.padding.top)
              : (query.size.width -
                  query.viewInsets.left -
                  query.padding.left)) /
          1.5,
      child: (workouts.workoutsList.length > 0)
          ? GridView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(top: 10, left: 5, bottom: 10, right: 5),
              shrinkWrap: true,
              itemBuilder: (ctx, i) =>
                  _buildWorkoutCard(workouts.workoutsList[i]),
              itemCount: workouts.workoutsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
            )
          : noDataWidget,
    );
  }
}
