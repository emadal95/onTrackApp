import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/tools_icons.dart';
import 'package:gym_tracker/models/exercise.dart';

class ExercisesDropdown extends StatefulWidget {
  Function onExerciseSelected;
  List<Exercise> exercisesToDisplay;
  ExercisesDropdown({this.onExerciseSelected, this.exercisesToDisplay});

  @override
  _ExercisesDropdownState createState() => _ExercisesDropdownState();
}

class _ExercisesDropdownState extends State<ExercisesDropdown> {
  Exercise _selectedExercise;

  onExerciseSelected(selection) {
    setState(() {
      _selectedExercise = selection;
      widget.onExerciseSelected(selection);
    });
  }

  List<DropdownMenuItem> get exerciseDropdownItems {
    return widget.exercisesToDisplay
        .map(
          (exercise) => DropdownMenuItem(
            value: exercise,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(exercise.icon),
                SizedBox(width: 20),
                AutoSizeText(exercise.name),
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedExercise == null && widget.exercisesToDisplay.length > 0) _selectedExercise = widget.exercisesToDisplay[0];

    return DropdownButton(
      iconSize: 14,
      icon: Icon(ToolsIcons.chevron_down_circle),
      isExpanded: true,
      underline: Padding(
        padding: EdgeInsets.all(0),
      ), //to disable underline
      items: exerciseDropdownItems,
      onChanged: (selection) => onExerciseSelected(selection),
      value: _selectedExercise,
    );
  }
}
