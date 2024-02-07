import 'package:flutter/material.dart';
import 'package:gym_tracker/database/app_db.dart';
import 'package:gym_tracker/database/query_helper.dart';
import 'package:gym_tracker/models/exercise.dart';
import 'package:gym_tracker/providers/exercises_provider.dart';
import 'package:gym_tracker/widgets/customs/horizontal_draggable_page_bar.dart';
import 'package:gym_tracker/widgets/exercises/new_exercise_form.dart';
import 'package:provider/provider.dart';

class ExerciseCreationScreen extends StatefulWidget {
  bool editMode;
  String idForEdit;

  ExerciseCreationScreen({this.editMode = false, this.idForEdit});

  _ExerciseCreationScreenState createState() => _ExerciseCreationScreenState();
}

class _ExerciseCreationScreenState extends State<ExerciseCreationScreen> {
  final double toolbarHeight = 36;
  var viewSize;
  bool isFormValid;
  NewExerciseForm exerciseForm;

  @override
  void initState() {
    super.initState();
    isFormValid = (widget.editMode) ? true : false;
    exerciseForm = NewExerciseForm(
      nameChangedListener: _onNameUpdatedListener,
      editMode: widget.editMode,
      idForEdit: widget.idForEdit,
    );
  }

  void _onSave() {
    Provider.of<ExercisesProvider>(context)
        .addExercise(exerciseForm.exerciseFormResult);
    _submitNewExercise();
    Navigator.of(context).pop(exerciseForm.exerciseFormResult.id);
  }

  void _onUpdate() {
    Provider.of<ExercisesProvider>(context)
        .updateExercise(exerciseForm.exerciseFormResult);
    _submitNewExercise();
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

  Future _submitNewExercise() async {
    Exercise newExercise = exerciseForm.exerciseFormResult;
    print('Saving new Exercise to db...');
    var data = QueryHelper.toQueryExerciseData(newExercise);
    return await AppDatabase().insertExercise(data);
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
            (widget.editMode) ? Icons.check_circle : Icons.add_circle,
            (widget.editMode)
                ? Icons.check_circle_outline
                : Icons.add_circle_outline,
            Theme.of(context).accentColor,
            (isFormValid) ? ((widget.editMode) ? _onUpdate : _onSave) : null,
          ),
        ),
      ],
    );
  }

  Widget get form {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 5, bottom: 40, right: 20, left: 20),
        child: exerciseForm,
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
