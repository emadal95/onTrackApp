import 'package:flutter/material.dart';
import 'package:gym_tracker/database/app_db.dart';
import 'package:gym_tracker/database/query_helper.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/providers/exercises_provider.dart';
import 'package:gym_tracker/providers/workouts_provider.dart';
import 'package:gym_tracker/widgets/customs/horizontal_draggable_page_bar.dart';
import 'package:gym_tracker/widgets/workouts/new_workout_form.dart';
import 'package:provider/provider.dart';

class WorkoutCreationScreen extends StatefulWidget {
  static final String routeName = '/workoutCreation';
  bool editMode;
  String idForEdit;
  List<String> workoutExercisesIds;

  WorkoutCreationScreen(
      {this.editMode = false, this.idForEdit, this.workoutExercisesIds});

  _WorkoutCreationScreenState createState() => _WorkoutCreationScreenState();
}

class _WorkoutCreationScreenState extends State<WorkoutCreationScreen> {
  final double toolbarHeight = 36;
  var viewSize;
  bool isFormValid;
  NewWorkoutForm workoutForm;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    isFormValid = (widget.editMode) ? true : false;
    workoutForm = NewWorkoutForm(
      nameChangedListener: _onNameUpdatedListener,
      notesTapListener: _onNotesTap,
      editMode: widget.editMode,
      idForEdit: widget.idForEdit,
      pickedExercisesId: widget.workoutExercisesIds,
    );
  }

  void _onDiscard() {
    Navigator.of(context).pop();
  }

  void _onSave() {
    Workout newWorkout = workoutForm.workoutFormResult;
    //Add Picked Exercises:
    workoutForm.workoutExercisesId.forEach(
      (exerciseId) => newWorkout.addExercise(
        Provider.of<ExercisesProvider>(context).getExerciseById(exerciseId),
      ),
    );
    Provider.of<WorkoutsProvider>(context).addWorkout(newWorkout);
    _submitNewWorkout();
    Navigator.of(context).pop();
  }

  void _onUpdate() {
    Workout newWorkout = workoutForm.workoutFormResult;
    newWorkout.exercises = [];
    //Add Picked Exercises:
    workoutForm.workoutExercisesId.forEach(
      (exerciseId) => newWorkout.addExercise(
        Provider.of<ExercisesProvider>(context).getExerciseById(exerciseId),
      ),
    );
    Provider.of<WorkoutsProvider>(context)
        .updateWorkout(newWorkout.id, newWorkout);
    _submitNewWorkout();
    Navigator.of(context).pop();
  }

  void _onNameUpdatedListener(String newName) {
    setState(() {
      if (newName != null && newName.isNotEmpty)
        isFormValid = true;
      else
        isFormValid = false;
    });
  }

  void _onNotesTap() {
    var scrollPosition = _scrollController.position;

    _scrollController.animateTo(
      scrollPosition.maxScrollExtent,
      duration: new Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  Future _submitNewWorkout() async {
    Workout newWorkout = workoutForm.workoutFormResult;
    print('Saving new Workout to db...');
    var data = QueryHelper.toQueryWorkoutData(newWorkout);
    return await AppDatabase().insertWorkout(data);
  }

  Widget _buildToolBarIcon(
      IconData icon, IconData inactiveIcon, Color iconColor, Function onTap) {
    return IconButton(
      icon: Icon(
        (onTap != null) ? icon : inactiveIcon,
        size: 30,
      ),
      onPressed: onTap,
      disabledColor: Colors.grey,
      color: iconColor,
    );
  }

  Widget get topToolbar {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: toolbarHeight, height: toolbarHeight),
        HorizontalDraggablePageBar(barColor: Theme.of(context).primaryColor),
        Container(
          height: toolbarHeight,
          width: toolbarHeight,
          child: _buildToolBarIcon(
              (!widget.editMode) ? Icons.add_circle : Icons.check_circle,
              (!widget.editMode)
                  ? Icons.add_circle_outline
                  : Icons.check_circle_outline,
              Theme.of(context).accentColor,
              (isFormValid)
                  ? ((!widget.editMode) ? _onSave : _onUpdate)
                  : null),
        ),
      ],
    );
  }

  Widget get form {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 40, top: 5, right: 20, left: 20),
        controller: _scrollController,
        child: workoutForm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    viewSize = MediaQuery.of(context).size;

    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      child: Column(
        children: <Widget>[topToolbar, form],
      ),
    );
  }
}
