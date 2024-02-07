import 'package:flutter/material.dart';
import 'package:gym_tracker/models/utils/human_body.dart';

class BodyPartIcon extends StatelessWidget {
  BODYPARTS part;
  double iconSize;
  
  BodyPartIcon({this.part, this.iconSize = 30});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.amber, width: 1),
          borderRadius: BorderRadius.circular(100)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 1.3),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.amber, width: 1),
            borderRadius: BorderRadius.circular(100)),
        child: Align(
          alignment: Alignment.center,
          child: Icon(
            HumanBody.mapToIcon(part),
            size: iconSize,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}