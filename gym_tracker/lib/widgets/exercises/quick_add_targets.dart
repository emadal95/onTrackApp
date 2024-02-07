import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/models/utils/human_body.dart';

class QuickAddTargets extends StatefulWidget {
  Function onTargetSelected;
  List<BODYPARTS> selectedTargets;
  QuickAddTargets({this.onTargetSelected, this.selectedTargets});

  @override
  _QuickAddTargetsState createState() => _QuickAddTargetsState();
}

class _QuickAddTargetsState extends State<QuickAddTargets> {
  void _onTargetTapped(BODYPARTS target) {
    widget.onTargetSelected(target);
  }

  Widget _buildTargetEntry(target) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(2),
          margin: EdgeInsets.only(right: 10, left:10, bottom:6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              width: 2,
              color: (widget.selectedTargets.contains(target))
                  ? Theme.of(context).accentColor
                  : Colors.transparent,
            ),
          ),
          child: GestureDetector(
            onTap: () => _onTargetTapped(target),
            child: CircleAvatar(
              radius: 22,
              child: Icon(
                HumanBody.mapToIcon(target),
                color: Colors.white,
                size: 24,
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ),
        AutoSizeText(
          HumanBody.mapPartToString(target),
          maxLines: 1,
          maxFontSize: 10,
          minFontSize: 4,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(bottom: 8),
              child: Text(
                "Pick body targets",
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                //margin: EdgeInsets.symmetric(horizontal: 10),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  runSpacing: 10,
                  spacing: 10,
                  children: BODYPARTS.values
                      .map((target) => _buildTargetEntry(target))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
