import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/models/exercise_session.dart';
import 'package:gym_tracker/models/set_weight.dart';
import 'package:gym_tracker/widgets/exercise_sessions/set_widget.dart';
import 'package:gym_tracker/models/set.dart';

class ExerciseSessionLogs extends StatefulWidget {
  ExerciseSession exerciseSession;
  List<Set> sets;

  ExerciseSessionLogs({@required this.exerciseSession}) {
    sets = [
      new Set(id: UniqueKey().toString(), exerciseSessionId: exerciseSession.id)
    ]; //there is always at least one set
  }

  List<Set> get newSets {
    return sets;
  }

  _ExerciseSessionLogsState createState() => _ExerciseSessionLogsState();
}

class _ExerciseSessionLogsState extends State<ExerciseSessionLogs> {
  int setsCount = 1;

  void _addSet() {
    setState(() {
      setsCount++;
      widget.sets.add(
        new Set(
          id: UniqueKey().toString(),
          exerciseSessionId: widget.exerciseSession.id,
        ),
      );
    });
  }

  void _removeSet() {
    setState(() {
      if (setsCount - 1 > 1) {
        setsCount--;
        widget.sets.removeLast();
      } else
        setsCount = 1;
    });
  }

  Widget _buildButton({Color color, IconData icon, Function onPress}) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Theme.of(context).primaryColor),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildSetsLabel() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: AutoSizeText(
        '${setsCount} set${(setsCount > 1) ? 's' : ''}',
        style: Theme.of(context).textTheme.headline,
      ),
    );
  }

  Widget _buildSetsCounter() {
    return Card(
      //color: Colors.black87.withOpacity(0.8),
      margin: EdgeInsets.only(top: 16, bottom: 8, right: 5, left: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton(
              //color: Colors.redAccent.withOpacity(0.8),
              icon: Icons.remove,
              onPress: _removeSet,
            ),
            _buildSetsLabel(),
            _buildButton(
              //color:Colors.greenAccent,
              icon: Icons.add,
              onPress: _addSet,
            )
          ],
        ),
      ),
    );
  }

  void _onSetRepsChanged({int setNumber, int reps}) {
    var setIdx = setNumber - 1;
    widget.sets[setIdx].reps = reps;
  }

  void _onSetWeightChanged({int setNumber, SetWeight weight}) {
    var setIdx = setNumber - 1;
    widget.sets[setIdx].weightUsed = weight;
  }

  List<Widget> _buildSetWidget() {
    List<Widget> cards = [];
    for (int i = 1; i <= setsCount; i++) {
      cards.add(
        Card(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: SetWidget(
              setNumber: i,
              exerciseSession: widget.exerciseSession,
              setToLoad:
                  ((i - 1) < widget.sets.length) ? widget.sets[i - 1] : null,
              onSetRepsChanged: _onSetRepsChanged,
              onSetWeightChanged: _onSetWeightChanged),
        ),
      );
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      verticalDirection: VerticalDirection.down,
      children: <Widget>[
        _buildSetsCounter(),
        Scrollbar(
          child: Column(
            children: <Widget>[..._buildSetWidget()],
          ),
        )
      ],
    );
  }
}
