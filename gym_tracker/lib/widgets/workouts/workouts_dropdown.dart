import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/tools_icons.dart';
import 'package:gym_tracker/models/workout.dart';

class WorkoutsDropdown extends StatefulWidget {
  Function onWorkoutSelected;
  List<Workout> workoutsToDisplay;

  WorkoutsDropdown({this.onWorkoutSelected, this.workoutsToDisplay});

  @override
  _WorkoutsDropdownState createState() => _WorkoutsDropdownState();
}

class _WorkoutsDropdownState extends State<WorkoutsDropdown> {
  Workout _selectedWorkout;

  void _onWorkoutSelected(newWorkout){
    setState(() {
      this._selectedWorkout = newWorkout;
      widget.onWorkoutSelected(newWorkout);
    });
  }

  List<DropdownMenuItem> get workoutDropdownItems {
    return widget.workoutsToDisplay
        .map(
          (Workout workout) => DropdownMenuItem(
            value: workout,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(workout.icon),
                SizedBox(width: 20),
                AutoSizeText(workout.name),
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
   if (_selectedWorkout == null && widget.workoutsToDisplay.length > 0) _selectedWorkout = widget.workoutsToDisplay[0];

    return DropdownButton(
      iconSize: 14,
      icon: Icon(ToolsIcons.chevron_down_circle),
      isExpanded: true,
      underline: Padding(
        padding: EdgeInsets.all(0),
      ), //to disable underline
      items: workoutDropdownItems,
      onChanged: (selection) => _onWorkoutSelected(selection),
      value: _selectedWorkout,
    );
  }
}