import 'dart:math';
import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/chart_icons.dart';
import 'package:gym_tracker/icons/workout_icons.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:gym_tracker/providers/exercises_provider.dart';
import 'package:provider/provider.dart';
import '../body_parts/body_part_picker.dart';
import '../customs/icon_picker.dart';
import '../customs/intensity_picker.dart';
import '../customs/notes_field.dart';

class NewExerciseForm extends StatefulWidget {
  Exercise newExercise;
  String id;
  Function nameChangedListener;
  String idForEdit;
  bool editMode;

  NewExerciseForm({this.nameChangedListener, this.editMode, this.idForEdit}) {
    id = (editMode) ? idForEdit : UniqueKey().toString();
    newExercise = (!editMode)
        ? Exercise(
            id: id,
            icon: WorkoutIcons.getWorkoutIcons().first,
          )
        : null;
  }

  Exercise get exerciseFormResult {
    return newExercise;
  }

  _NewExerciseFormState createState() => _NewExerciseFormState();
}

class _NewExerciseFormState extends State<NewExerciseForm> {
  TextEditingController exerciseNameController = new TextEditingController();
  FocusNode equipmentFocusNode = FocusNode();

  void _onIconChangedListener({IconData newIcon}) {
    setState(() {
      widget.newExercise.icon = newIcon;
    });
  }

  void _onNameChanged(String newName) {
    widget.newExercise.name = newName;
    widget.nameChangedListener(newName);
    FocusScope.of(context).requestFocus(equipmentFocusNode);
  }

  void _onEquipmentChanged(String newEquipment) {
    widget.newExercise.equipment = newEquipment;
  }

  void _onIntensityPickedListener(intensity) {
    widget.newExercise.level = intensity;
  }

  void _onBodyPartTappedlistener(BODYPARTS bodypart) {
    setState(() {
      if (widget.newExercise.bodyParts.contains(bodypart))
        widget.newExercise.bodyParts.remove(bodypart);
      else
        widget.newExercise.bodyParts.add(bodypart);
    });
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
                widget.newExercise.icon,
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
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
          autocorrect: false,
          controller: exerciseNameController,
          autovalidate: true,
          maxLength: 20,
          validator: (name) => (name.isEmpty) ? 'Exercise name required' : null,
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
              labelText: 'Exercise name',
              suffixIcon: Icon(
                Icons.edit,
                size: 15,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(12)),
              contentPadding: EdgeInsets.all(10))),
    );
  }

  Widget _buildEquipmentFormEntry() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        autocorrect: false,
        focusNode: equipmentFocusNode,
        autovalidate: false,
        initialValue: (widget.editMode) ? widget.newExercise.equipment : null,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (String newEquipment) =>
            _onEquipmentChanged(newEquipment),
        decoration: InputDecoration(
            labelText: 'Equipment',
            suffixIcon: Icon(
              WorkoutIcons.dumbbell,
              size: 15,
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.all(10)),
      ),
    );
  }

  Widget _buildToolBar(
      {String title,
      IconData icon,
      Function onTap,
      double iconSize,
      bool noBar = false,
      double bottomPadding,
      double topPadding = 30}) {
    return Container(
      height: 30,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: bottomPadding, top: topPadding),
      decoration: BoxDecoration(
        border: (!noBar)
            ? Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              )
            : null,
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

  Widget get iconPicker {
    return IconPicker(
      onIconChanged: _onIconChangedListener,
      availableIcons: WorkoutIcons.getWorkoutIcons(),
      selectedIcon: widget.newExercise.icon,
    );
  }

  List<Widget> get intensityPicker {
    return [
      _buildToolBar(
          title: 'Intensity',
          icon: ChartIcons.chart_bar_2,
          onTap: null,
          iconSize: 16,
          bottomPadding: 10,
          topPadding: 30),
      IntensityPicker(
        onIntensitySelected: _onIntensityPickedListener,
        initialValue: widget.newExercise.level,
      )
    ];
  }

  Widget get notesField {
    return NotesField(
      onNotesSubmitted: (notes) => widget.newExercise.about = notes,
      initialValue: widget.newExercise.about,
    );
  }

  List<Widget> get bodyPartPicker {
    return [
      _buildToolBar(
          title: 'Targets',
          icon: Icons.filter_center_focus,
          onTap: null,
          iconSize: 15,
          noBar: true,
          bottomPadding: 0,
          topPadding: 20),
      BodyPartsPicker(
        onBodyPartTapped: _onBodyPartTappedlistener,
        bodyPartsSelected: widget.newExercise.bodyParts,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.editMode) {
      widget.newExercise =
          Provider.of<ExercisesProvider>(context).getExerciseById(widget.id);
      exerciseNameController =
          TextEditingController(text: widget.newExercise.name);
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
            _buildEquipmentFormEntry(),
            ...intensityPicker,
            ...bodyPartPicker,
            _buildSectionTitle(title: 'Notes', topPadding: 30),
            notesField,
          ],
        ),
      ),
    );
  }
}
