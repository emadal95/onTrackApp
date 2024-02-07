import 'package:flutter/material.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/providers/workouts_provider.dart';
import 'package:gym_tracker/screens/workout_creation_screen.dart';
import 'package:gym_tracker/widgets/customs/dialogs.dart';
import 'package:gym_tracker/widgets/customs/dismissible_background.dart';
import 'package:gym_tracker/widgets/workouts/workout_card.dart';
import 'package:provider/provider.dart';

class CustomWorkoutsScreen extends StatefulWidget {
  static final String routeName = '/customWorkouts';
  _CustomWorkoutsScreenState createState() => _CustomWorkoutsScreenState();
}

class _CustomWorkoutsScreenState extends State<CustomWorkoutsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool showingBottomSheet;
  WorkoutsProvider workouts;

  @override
  void initState() {
    showingBottomSheet = false;
    super.initState();
  }

  void _addNewWorkout() {
    setState(() {
      showingBottomSheet = true;
    });
    scaffoldKey.currentState.showBottomSheet(
      (ctx) => WorkoutCreationScreen(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        side: BorderSide(width: 0.5, color: Colors.black87.withOpacity(0.2)),
      ),
      elevation: 20,
      backgroundColor: Theme.of(context).backgroundColor,
    );
    /*Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => WorkoutCreationScreen(), fullscreenDialog: true));*/
  }

  void _removeWorkout(String id) {
    workouts.removeWorkout(id, context);
  }

  void _editWorkout({String workoutId}) {
    List<String> workoutExercisesIds = Provider.of<WorkoutsProvider>(context)
        .getWorkoutById(workoutId)
        .exercises
        .map((ex) => ex.id)
        .toList();

    scaffoldKey.currentState.showBottomSheet(
      (ctx) => WorkoutCreationScreen(
        editMode: true,
        idForEdit: workoutId,
        workoutExercisesIds: workoutExercisesIds,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        side: BorderSide(width: 0.5, color: Colors.black87.withOpacity(0.2)),
      ),
      elevation: 20,
      backgroundColor: Theme.of(context).backgroundColor,
    );

    /*Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => WorkoutCreationScreen(
        editMode: true,
        idForEdit: workoutId,
        workoutExercisesIds: workoutExercisesIds,
      ),
      fullscreenDialog: true,
    ));*/
  }

  Widget _buildWorkoutCardEntry(Workout workout) {
    return Dismissible(
      key: UniqueKey(),
      dismissThresholds: {DismissDirection.endToStart: 0.75},
      background: DismissibleBackground(context).delete,
      direction: DismissDirection.endToStart,
      onDismissed: (dir) => _removeWorkout(workout.id),
      confirmDismiss: Dialogs(context).confirmRemoveDialog,
      child: _buildWorkoutCard(workout),
    );
  }

  Widget _buildWorkoutCard(Workout workout) {
    if (workout.name != null && workout.name.isNotEmpty)
      return WorkoutCard(
        workout: workout,
        onCardTap: _editWorkout,
      );
    else {
      workouts.removeWorkoutWithoutNotifying(workout.id, context);
      return null;
    }
  }

  List<Widget> get sectionDivider {
    return [
      Divider(),
      SizedBox(height: 10),
    ];
  }

  List<Widget> get appBarActions {
    return [
      IconButton(
        onPressed: _addNewWorkout,
        icon: Icon(Icons.add),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if(workouts == null)
      workouts = Provider.of<WorkoutsProvider>(context);

    return Stack(
      children: <Widget>[
        Scaffold(
          key: scaffoldKey,
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            title: Text('My Workouts'),
            actions: <Widget>[
              ...appBarActions,
            ],
          ),
          body: (workouts.workoutsList.length > 0)
              ? ListView.separated(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                  shrinkWrap: true,
                  itemBuilder: (ctx, i) =>
                      _buildWorkoutCardEntry(workouts.workoutsList[i]),
                  itemCount: workouts.workoutsList.length,
                  separatorBuilder: (ctx, i) => SizedBox(
                    height: 15,
                  ),
                )
              : Center(
                  child: Text(
                    'You have not added any workouts yet',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
        ),
      ],
    );
  }
}
