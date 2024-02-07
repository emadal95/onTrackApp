import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/navigation_icons.dart';
import 'package:gym_tracker/models/utils/intensity.dart';
import 'package:gym_tracker/models/utils/intensity.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class IntensityPicker extends StatefulWidget {
  Function onIntensitySelected;
  INTENSITY_LEVEL initialValue;
  IntensityPicker({this.onIntensitySelected, this.initialValue});

  _IntensityPickerState createState() => _IntensityPickerState();
}

class _IntensityPickerState extends State<IntensityPicker> {
  var _selectedIntensity;

  @override
  void initState() {
    _selectedIntensity = (widget.initialValue == null) ? INTENSITY_LEVEL.LOW : widget.initialValue;
    widget.onIntensitySelected(_selectedIntensity);
    super.initState();
  }

  void _onIntensitySelected(intensity) {
    setState(() {
      _selectedIntensity = intensity;
      widget.onIntensitySelected(intensity);
    });
  }

  Widget _buildIntensityIndicatorFor(INTENSITY_LEVEL level) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: CircularPercentIndicator(
        radius: 18,
        lineWidth: 2,
        percent: Intensity.mapToIntensityPercentage(level),
        progressColor: Intensity.mapToColor(level),
        circularStrokeCap: CircularStrokeCap.round,
      ),
    );
  }

  List<DropdownMenuItem> get dropdownItems {
    return INTENSITY_LEVEL.values
        .map(
          (level) => DropdownMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  Intensity.mapToString(level),
                ),
                _buildIntensityIndicatorFor(level)
              ],
            ),
            value: level,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: DropdownButton(
          style: Theme.of(context).textTheme.subhead,
          underline: Padding(padding: EdgeInsets.all(0),), //to disable underline
          isExpanded: true,
          icon: Icon(NavigationIcons.chevron_down, size: 18,),
          items: dropdownItems,
          onChanged: (intensity) => _onIntensitySelected(intensity),
          value: _selectedIntensity),
    );
  }
}
