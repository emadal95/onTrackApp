import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/models/exercise.dart';

class ExerciseSmallCard extends StatefulWidget {
  Exercise exercise;
  int descriptionMaxLines;
  bool highlighted;

  ExerciseSmallCard(
      {@required this.exercise,
      this.descriptionMaxLines = 3,
      this.highlighted = false});

  @override
  _ExerciseSmallCardState createState() => _ExerciseSmallCardState();
}

class _ExerciseSmallCardState extends State<ExerciseSmallCard> {
  BuildContext context;

  Widget title(String title) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.title,
    );
  }

  Widget about(String about) {
    return Text(
      (about != null) ? about : '',
      textAlign: TextAlign.justify,
      maxLines: widget.descriptionMaxLines,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.caption,
    );
  }

  Widget equipment(String equipment) {
    return Text(
      (equipment == null || equipment.isEmpty) ? 'Equipment free' : equipment,
      textAlign: TextAlign.justify,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.caption.copyWith(
            decoration: TextDecoration.none,
            decorationThickness: 1,
            fontWeight: FontWeight.w600,
            fontFamily: Theme.of(context).textTheme.display1.fontFamily,
            fontSize: 10,
          ),
    );
  }

  Widget get bottomDot {
    return Container(
      height: 5,
      width: 5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Theme.of(context).textTheme.caption.color),
    );
  }

  RoundedRectangleBorder get cardShape {
    return (widget.highlighted)
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Theme.of(context).accentColor),
          )
        : RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Card(
      shape: cardShape,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(widget.exercise.icon),
            SizedBox(height: 10),
            title(widget.exercise.name),
            Divider(),
            about(widget.exercise.about),
            Divider(),
            equipment(widget.exercise.equipment),
            //SizedBox(height: 2,),
            //bottomDot,
          ],
        ),
      ),
    );
  }
}
