import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/database/app_db.dart';
import 'package:gym_tracker/models/user_weigth.dart';
import 'package:gym_tracker/models/utils/unit.dart';
import 'package:gym_tracker/models/utils/weight.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:intl/intl.dart';

class WeightCard extends StatefulWidget {
  int i;
  UserProvider user;

  WeightCard({this.user, this.i});

  @override
  _WeightCardState createState() => _WeightCardState();
}

class _WeightCardState extends State<WeightCard> {
  _removeUserWeight(id) async {
    widget.user.removeUserWeight(id);
    await AppDatabase().removeWeight(id);
  }

  Widget _buildWeightCircle() {
    return CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: AutoSizeText(
            Weight.mapToString(widget.user.userWeightsList[widget.i].weight,
                widget.user.weightUnit, 1),
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
            maxLines: 1,
            maxFontSize: 12,
            minFontSize: 2,
            wrapWords: true,
          ),
        ),
      //),
    );
  }

  Widget _buildDateLabel() {
    return //Padding(
      //padding: const EdgeInsets.only(left: 10, right: 10), child: 
      AutoSizeText(
        DateFormat.yMMMd().format(widget.user.userWeightsList[widget.i].date),
        style: Theme.of(context).textTheme.subhead,
        textAlign: TextAlign.start,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      //),
    );
  }

  Widget _buildCard() {
    return Card(
      margin: EdgeInsets.all(0),
      child: Row(
        children: <Widget>[
          _buildWeightCircle(),
          _buildDateLabel(),
        ],
      ),
    );
  }

  Widget _dismissibleBackground() {
    return Card(
      color: Colors.redAccent,
      margin: EdgeInsets.all(0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var id = widget.user.userWeightsList[widget.i].id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        direction: DismissDirection.endToStart,
        background: _dismissibleBackground(),
        onDismissed: (direction) => _removeUserWeight(id),
        key: Key(id),
        child: _buildCard(),
      ),
    );
  }
}
