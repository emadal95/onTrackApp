import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/models/utils/intensity.dart';
import 'package:percent_indicator/percent_indicator.dart';

class QuickAddIntensity extends StatefulWidget {
  Function onIntensityPicked;
  INTENSITY_LEVEL pickedLevel;
  QuickAddIntensity(
      {@required this.onIntensityPicked, @required this.pickedLevel});

  @override
  _QuickAddIntensityState createState() => _QuickAddIntensityState();
}

class _QuickAddIntensityState extends State<QuickAddIntensity> {
  INTENSITY_LEVEL picked;

  @override
  void initState() {
    super.initState();
    picked = widget.pickedLevel;
  }

  void _onPickedLevel(INTENSITY_LEVEL newLevel) {
    setState(() {
      picked = newLevel;
    });
    widget.onIntensityPicked(newLevel);
  }

  Widget _buildLevelEntry(INTENSITY_LEVEL level) {
    return GestureDetector(
      onTap: () => _onPickedLevel(level),
          child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: (picked == level)
                  ? Theme.of(context).accentColor
                  : Colors.transparent,
            ),
          ),
        ),
        child: CircularPercentIndicator(
          radius: 30,
          animation: true,
          animationDuration: 700,
          progressColor: Intensity.mapToColor(level),
          percent: Intensity.mapToIntensityPercentage(level),
          circularStrokeCap: CircularStrokeCap.round,
          footer: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: AutoSizeText(
              Intensity.mapToString(level),
              maxLines: 1,
              maxFontSize: 10,
              minFontSize: 4,
            ),
          ),
        ),
      ),
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
              child: Text(
                "Pick itensity",
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  runSpacing: 10,
                  spacing: 10,
                  children: INTENSITY_LEVEL.values
                      .map((level) => _buildLevelEntry(level))
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
