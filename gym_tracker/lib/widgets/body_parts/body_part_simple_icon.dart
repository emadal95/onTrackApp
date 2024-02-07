import 'package:flutter/material.dart';
import 'package:gym_tracker/models/utils/human_body.dart';

class BodyPartSimpleIcon extends StatelessWidget {
  BODYPARTS part;
  double size;
  BodyPartSimpleIcon({this.part, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1)),
      child: Icon(
        HumanBody.mapToIcon(part),
        size: size,
      ),
    );
  }
}
