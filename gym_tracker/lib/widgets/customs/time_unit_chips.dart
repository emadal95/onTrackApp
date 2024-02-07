import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

enum TIMEUNITS { seconds, minutes }

class TimeUnitChips extends StatefulWidget {
  Function onUnitSelected;
  TIMEUNITS initialSelection;

  TimeUnitChips(
      {this.onUnitSelected, this.initialSelection = TIMEUNITS.seconds});

  @override
  _TimeUnitChipsState createState() => _TimeUnitChipsState();
}

class _TimeUnitChipsState extends State<TimeUnitChips> {
  TIMEUNITS selection;

  @override
  void initState() {
    super.initState();
    this.selection = widget.initialSelection;
  }

  _onUnitSelection (TIMEUNITS unit){
    setState(() {
      this.selection = unit;
      widget.onUnitSelected(unit);
    });
  }

  Widget _buildChip(String label, TIMEUNITS unitType) {
    return GestureDetector(
      onTap: () => _onUnitSelection(unitType),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: (selection == unitType)
              ? Colors.black
              : Theme.of(context).chipTheme.backgroundColor,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.body1.copyWith(
                color: (selection == unitType) ? Colors.white : Colors.black,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildChip('sec', TIMEUNITS.seconds),
          _buildChip('min', TIMEUNITS.minutes)
        ],
      ),
    );
  }
}
