import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gym_tracker/database/app_db.dart';
import 'package:gym_tracker/database/query_helper.dart';
import 'package:gym_tracker/icons/navigation_icons.dart';
import 'package:gym_tracker/icons/workout_icons.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:gym_tracker/models/utils/intensity.dart';
import 'package:gym_tracker/providers/exercises_provider.dart';
import 'package:gym_tracker/widgets/body_parts/body_part_picker.dart';
import 'package:gym_tracker/widgets/exercises/exercise_quick_add_icons.dart';
import 'package:gym_tracker/widgets/exercises/exercise_quick_add_intensity.dart';
import 'package:gym_tracker/widgets/exercises/exercise_quick_add_text.dart';
import 'package:gym_tracker/widgets/exercises/quick_add_targets.dart';
import 'package:provider/provider.dart';

class ExerciseQuickAdd extends StatefulWidget {
  bool editMode;
  Exercise exerciseToLoad;
  ExerciseQuickAdd({this.editMode = false, this.exerciseToLoad});

  @override
  _ExerciseQuickAddState createState() => _ExerciseQuickAddState();
}

class _ExerciseQuickAddState extends State<ExerciseQuickAdd> {
  final Duration pageTransitionDuration = Duration(milliseconds: 200);
  final Curve pageTransitionCurve = Curves.linear;
  PageController pageController;
  int _currentPageIdx;
  List<bool> skip; //matching index with pages
  Exercise newExercise;
  List<Widget> pages;

  @override
  void initState() {
    newExercise = (widget.editMode)
        ? widget.exerciseToLoad
        : new Exercise(
            id: UniqueKey().toString(),
            icon: WorkoutIcons.getWorkoutIcons()[0],
            name: "",
            about: "",
            bodyParts: [],
            equipment: "",
            level: INTENSITY_LEVEL.LOW,
          );

    pageController = new PageController(initialPage: 0, keepPage: true);
    _currentPageIdx = 0;

    super.initState();
  }

  void initPages() {
    pages = [
      QuickAddIcons(
        onIconPicked: _onIconPicked,
        iconsData: WorkoutIcons.getWorkoutIcons(),
        pickedIcon: newExercise.icon,
      ),
      QuickAddText(
        onSubmit: _onAddName,
        pickedText: newExercise.name,
        pageTitle: "Pick name",
        fieldName: "Exercise name",
        validationErrorMsg: "Exercise name required",
      ),
      QuickAddText(
        onSubmit: _onAddEquipment,
        pickedText: newExercise.equipment,
        pageTitle: "Pick equipment",
        fieldName: "Equipment",
        needsValidation: false,
      ),
      QuickAddIntensity(
        onIntensityPicked: _onIntensityPicked,
        pickedLevel: newExercise.level,
      ),
      QuickAddTargets(
        onTargetSelected: _onTargetPicked,
        selectedTargets: newExercise.bodyParts,
      ),
    ];
    skip = [
      /*icons page*/
      true,
      /*name page*/
      (widget.editMode && widget.exerciseToLoad.name.isNotEmpty || newExercise.name.isNotEmpty) ? true : false,
      /*equipment page*/
      true,
      /*intensity page*/
      true,
      /*targets page*/
      false,
    ];
  }

  void _onIconPicked(IconData icon) {
    newExercise.icon = icon;
    nextPage();
  }

  void _onAddName(String name) {
    newExercise.name = name;
    nextPage();
  }

  void _onAddEquipment(String equip) {
    newExercise.equipment = equip;
    nextPage();
  }

  void _onIntensityPicked(INTENSITY_LEVEL level) {
    newExercise.level = level;
    nextPage();
  }

  void _onTargetPicked(BODYPARTS target) {
    setState(() {
      if (newExercise.bodyParts.contains(target))
        newExercise.bodyParts.remove(target);
      else
        newExercise.bodyParts.add(target);
    });
  }

  void nextPage() {
    pageController.nextPage(
        duration: pageTransitionDuration, curve: pageTransitionCurve);
  }

  void submit() {
    if (newExercise.name.isEmpty) {
      showNameRequiredAlert();
      return;
    }
    if (widget.editMode)
      Provider.of<ExercisesProvider>(context).updateExercise(newExercise);
    else
      Provider.of<ExercisesProvider>(context).addExercise(newExercise);
    AppDatabase().insertExercise(QueryHelper.toQueryExerciseData(newExercise));
    Navigator.of(context).pop(newExercise.id);
  }

  void showNameRequiredAlert() {
    showDialog(
      context: context,
      barrierDismissible: true,
      child: AlertDialog(
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              pageController.jumpToPage(1);
            },
          )
        ],
        title: Text('Name required'),
        content: Text('Please enter exercise name before submitting'),
      ),
    );
  }

  Widget get topBar {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Quick Add'),
        if (_currentPageIdx == pages.length - 1)
          InkWell(
            onTap: submit,
            child: Text(
              (widget.editMode) ? 'Save' : 'Add',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  void goBack() {
    if (MediaQuery.of(context).viewInsets.bottom != 0)
      FocusScope.of(context).requestFocus(new FocusNode());
    pageController.previousPage(
        duration: pageTransitionDuration, curve: pageTransitionCurve);
  }

  Widget get footer {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (_currentPageIdx != 0)
            FlatButton.icon(
              icon: Icon(
                NavigationIcons.chevron_left,
                size: 14,
              ),
              label: Text("Back"),
              onPressed: goBack,
            ),
          if (_currentPageIdx == 0) Spacer(),
          if (skip[_currentPageIdx])
            FlatButton.icon(
              icon: Text("Next"),
              label: Icon(
                NavigationIcons.chevron_right,
                size: 14,
              ),
              onPressed: nextPage,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initPages();
    return Container(
      height: 280,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 22),
      margin: EdgeInsets.only(
          bottom: (MediaQuery.of(context).viewInsets.bottom > 0)
              ? MediaQuery.of(context).viewInsets.bottom - 100
              : 0),
      child: Column(
        children: <Widget>[
          topBar,
          Expanded(
            flex: 3,
            child: PageView(
              pageSnapping: true,
              physics: new NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: pageController,
              children: pages,
              onPageChanged: (idx) => setState(() {
                _currentPageIdx = idx;
              }),
            ),
          ),
          footer
        ],
      ),
    );
  }
}
