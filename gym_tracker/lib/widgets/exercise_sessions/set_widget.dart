import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/set_weight.dart';
import 'package:gym_tracker/models/utils/unit.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:gym_tracker/widgets/customs/weight_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/set.dart';

class SetWidget extends StatefulWidget {
  Set setToLoad;
  Set wigSet;
  int setNumber;
  Function({int setNumber, int reps}) onSetRepsChanged;
  Function({int setNumber, SetWeight weight}) onSetWeightChanged;
  ExerciseSession exerciseSession;

  SetWidget({this.setToLoad, @required this.setNumber, @required this.exerciseSession, this.onSetRepsChanged, this.onSetWeightChanged}){
    wigSet = (setToLoad == null)
        ? Set(
            id: UniqueKey().toString(),
            exerciseSessionId: exerciseSession.id
          )
        : setToLoad;
  }

  _SetWidgetState createState() => _SetWidgetState(newSet: wigSet);
}

class _SetWidgetState extends State<SetWidget> {
  TextEditingController repsLogController;
  Set newSet;

  _SetWidgetState({newSet}) {
    this.newSet = newSet;
  }

  void _onWeightSelected(double weightUsed) {
    var user = Provider.of<UserProvider>(context);
    newSet.weightUsed = (user.weightUnit == UNITS.KG)
        ? new SetWeight(id: UniqueKey().toString(), kg: weightUsed)
        : new SetWeight(id: UniqueKey().toString(), lb: weightUsed);
    widget.onSetWeightChanged(setNumber: widget.setNumber, weight: newSet.weightUsed);
  }

  void _onRepsLogged(String reps) {
    setState(() {
      newSet.setReps((reps.isEmpty) ? null : int.parse(reps));
      widget.onSetRepsChanged(setNumber: widget.setNumber, reps: newSet.reps);
    });
  }

  Widget _buildTitle() {
    return AutoSizeText(
      'Set ${widget.setNumber}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
      style: Theme.of(context)
          .textTheme
          .caption
          .copyWith(color: Theme.of(context).accentColor),
    );
  }

  Widget get repsLog {
    return TextFormField(
      autocorrect: false,
      autovalidate: true,
      validator: (repStr) =>
          (repStr.isNotEmpty && repStr != null && int.tryParse(repStr) == null)
              ? 'whole numbers only!'
              : null,
      controller: repsLogController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (String reps) => _onRepsLogged(reps),
      decoration: InputDecoration(
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).accentColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).accentColor),
        ),
        errorStyle: TextStyle(color: Theme.of(context).accentColor),
        labelText: 'Reps number',
        suffixIcon: Icon(
          Icons.repeat,
          size: 15,
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).hintColor),
            borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.all(10),
      ),
    );
  }

  Widget get divider {
    return Divider(
      color: Colors.amber,
      thickness: 1,
    );
  }

  Widget get sizeBox10h {
    return SizedBox(
      height: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    repsLogController = new TextEditingController(text: newSet.reps.toString());

    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        autovalidate: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildTitle(),
            divider,
            sizeBox10h,
            sizeBox10h,
            repsLog,
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: WeightDropdown(
                label: 'Weight used: ',
                onChanged: (weightUsed) => _onWeightSelected(weightUsed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
