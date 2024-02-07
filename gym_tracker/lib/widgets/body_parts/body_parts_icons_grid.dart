import 'package:flutter/material.dart';
import 'package:gym_tracker/models/utils/human_body.dart';
import 'package:gym_tracker/widgets/body_parts/body_part_icon.dart';

class BodyPartsIconsGrid extends StatelessWidget {
  List<BODYPARTS> parts;
  double iconSize;
  double maxCrossAxisExtent;
  BodyPartsIconsGrid({this.parts, this.iconSize, this.maxCrossAxisExtent});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: ScrollPhysics(), // to disable GridView's scrolling
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(0),
      itemBuilder: (ctx, i) => BodyPartIcon(part: parts[i], iconSize: iconSize,),
      itemCount: parts.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCrossAxisExtent,
        crossAxisSpacing: 1,
        mainAxisSpacing: 0,
      ),
    );
  }
}
