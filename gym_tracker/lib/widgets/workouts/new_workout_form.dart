import 'dart:math';
import 'package:animator/animator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/chart_icons.dart';
import 'package:gym_tracker/icons/workout_icons.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/providers/workouts_provider.dart';
import 'package:gym_tracker/screens/exercise_creation_screen.dart';
import 'package:gym_tracker/widgets/exercises/exercise_quick_add.dart';
import 'package:gym_tracker/widgets/exercises/exercises_picker.dart';
import 'package:gym_tracker/widgets/customs/icon_picker.dart';
import 'package:gym_tracker/widgets/customs/intensity_picker.dart';
import 'package:gym_tracker/widgets/customs/notes_field.dart';
import 'package:provider/provider.dart';

class NewWorkoutForm extends StatefulWidget {
  Workout newWorkout;
  bool editMode;
  String id;
  Function nameChangedListener;
  Function notesTapListener;
  List<String> pickedExercisesId = [];

  NewWorkoutForm({
    this.nameChangedListener,
    this.notesTapListener,
    this.editMode = false,
    this.pickedExercisesId,
    idForEdit,
  }) {
    pickedExercisesId = (pickedExercisesId == null) ? [] : pickedExercisesId;
    id = (!editMode) ? UniqueKey().toString() : idForEdit;
    newWorkout = (!editMode)
        ? Workout(id: id, icon: WorkoutIcons.getWorkoutIcons().first)
        : null;
  }

  Workout get workoutFormResult {
    return newWorkout;
  }

  List<String> get workoutExercisesId {
    return pickedExercisesId;
  }

  _NewWorkoutFormState createState() => _NewWorkoutFormState();
}

class _NewWorkoutFormState extends State<NewWorkoutForm> {
  TextEditingController workoutNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _onIconChangedListener({IconData newIcon}) {
    setState(() {
      widget.newWorkout.icon = newIcon;
    });
  }

  void _onNameChanged(String newName) {
    if (newName.isEmpty) return;
    widget.newWorkout.name = newName;
    widget.nameChangedListener(newName);
  }

  void _onExercisePickedListener(String id) {
    setState(() {
      if (widget.pickedExercisesId.contains(id)) {
        widget.pickedExercisesId.removeWhere((exId) => exId == id);
      } else {
        widget.pickedExercisesId.add(id);
      }
    });
  }

  void _onIntensityPickedListener(intensity) {
    widget.newWorkout.level = intensity;
  }

  void _onAddExercise() async {
    var createdId = await showModalBottomSheet(
      backgroundColor: Theme.of(context).backgroundColor,
      context: context,
      builder: (ctx) => ExerciseQuickAdd(),
      isDismissible: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      elevation: 25,
    );

    if (createdId != null) _onExercisePickedListener(createdId);
  }

  Widget _buildCircularIcon() {
    return Center(
      child: Container(
        height: 80,
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 10),
        child: Animator(
          tween: Tween<double>(begin: 0, end: pi * 2),
          repeats: 1,
          builder: (anim) => Transform.rotate(
            angle: anim.value,
            child: CircleAvatar(
              child: Icon(
                widget.newWorkout.icon,
                size: 40,
                color: Colors.white,
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
      {String title, double topPadding, double bottomPadding = 5}) {
    return Container(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Text(
        title,
        style: Theme.of(context).textTheme.caption,
      ),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _buildNameFormEntry() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        autocorrect: false,
        controller: workoutNameController,
        autovalidate: true,
        maxLength: 20,
        validator: (name) => (name.isEmpty) ? 'Workout name required' : null,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (String newName) => _onNameChanged(newName),
        decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).accentColor)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).accentColor)),
          errorStyle: TextStyle(color: Theme.of(context).accentColor),
          labelText: 'Workout name',
          suffixIcon: Icon(
            Icons.edit,
            size: 15,
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }

  Widget _buildToolBar(
      {String title, IconData icon, Function onTap, double iconSize}) {
    return Container(
      height: 30,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10, top: 30),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildSectionTitle(title: title, topPadding: 0, bottomPadding: 0),
          IconButton(
            alignment: Alignment.topCenter,
            icon: Icon(icon, size: iconSize),
            onPressed: onTap,
          ),
        ],
      ),
    );
  }

  bool get isFormValid {
    return workoutNameController.text.isNotEmpty;
  }

  Widget get iconPicker {
    return IconPicker(
      onIconChanged: _onIconChangedListener,
      availableIcons: WorkoutIcons.getWorkoutIcons(),
      selectedIcon: (widget.editMode) ? widget.newWorkout.icon : null,
    );
  }

  Widget get exercisesPicker {
    return ExercisesPicker(_onExercisePickedListener, widget.pickedExercisesId);
  }

  List<Widget> get intensityPicker {
    return [
      _buildToolBar(
          title: 'Intensity',
          icon: ChartIcons.chart_bar_2,
          onTap: null,
          iconSize: 15),
      IntensityPicker(
        onIntensitySelected: _onIntensityPickedListener,
        initialValue: (widget.editMode) ? widget.newWorkout.level : null,
      )
    ];
  }

  Widget get notesField {
    return NotesField(
      onNotesSubmitted: (notes) => widget.newWorkout.about = notes,
      onRequestNotesFocus: widget.notesTapListener,
      initialValue: (widget.editMode) ? widget.newWorkout.about : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.editMode) {
      widget.newWorkout =
          Provider.of<WorkoutsProvider>(context).getWorkoutById(widget.id);
      workoutNameController =
          TextEditingController(text: widget.newWorkout.name);
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Form(
        autovalidate: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildCircularIcon(),
            _buildSectionTitle(title: 'Pick icon', topPadding: 10),
            iconPicker,
            _buildNameFormEntry(),
            _buildToolBar(
              title: 'Exercises',
              icon: Icons.add,
              onTap: _onAddExercise,
              iconSize: 16,
            ),
            exercisesPicker,
            ...intensityPicker,
            _buildSectionTitle(title: 'Notes', topPadding: 30),
            notesField,
          ],
        ),
      ),
    );
  }
}
