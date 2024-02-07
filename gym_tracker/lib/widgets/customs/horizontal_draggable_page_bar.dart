import 'package:flutter/material.dart';

class HorizontalDraggablePageBar extends StatelessWidget {
  Color barColor;

  HorizontalDraggablePageBar({this.barColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.all(10),
      height: 4,
      width: 150,
    );
  }
}
