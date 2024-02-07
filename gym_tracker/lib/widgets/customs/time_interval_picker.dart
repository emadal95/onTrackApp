import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TimeIntervalPicker extends StatefulWidget {
  Function onDurationChange;
  Function onMeasurementChanged;
  String leadingText;
  TimeIntervalPicker(
      {this.onDurationChange, this.onMeasurementChanged, this.leadingText});

  @override
  _TimeIntervalPickerState createState() => _TimeIntervalPickerState();
}

class _TimeIntervalPickerState extends State<TimeIntervalPicker> {
  final List measures = ['Years', 'Months', 'Weeks', 'Days'];

  Widget _buildDurationRollingWheel() {
    return Container(
      width: 50,
      child: ListWheelScrollView(
        diameterRatio: 1.1,
        magnification: 2.0,
        onSelectedItemChanged: (selectedIdx) =>
            widget.onDurationChange('${selectedIdx + 1}'),
        children: List.generate(5, (i) => i + 1)
            .map((n) => AutoSizeText(
                  '$n',
                  maxLines: 1,
                ))
            .toList(),
        itemExtent: 18,
      ),
    );
  }

  _buildMeasurementRollingWheel() {
    return Container(
      width: 50,
      child: ListWheelScrollView(
        diameterRatio: 1.1,
        magnification: 2.0,
        onSelectedItemChanged: (selectionIdx) =>
            widget.onMeasurementChanged(measures[selectionIdx]),
        children: measures
            .map(
              (m) => AutoSizeText(
                '$m',
                maxLines: 1,
              ),
            )
            .toList(),
        itemExtent: 18,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 10),
            alignment: Alignment.centerRight,
            child: AutoSizeText(
              widget.leadingText,
            )),
        Flexible(flex: 1, child: _buildDurationRollingWheel()),
        Flexible(flex: 1, child: _buildMeasurementRollingWheel()),
      ],
    );
  }
}
