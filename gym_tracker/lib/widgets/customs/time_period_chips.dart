import 'package:flutter/material.dart';

enum TIMEPERIODS { total, week }

class TimePeriodChips extends StatefulWidget {
  Function onPeriodSelected;
  TIMEPERIODS initialSelection;

  TimePeriodChips({this.onPeriodSelected, this.initialSelection = TIMEPERIODS.week});

  @override
  _TimePeriodChipsState createState() => _TimePeriodChipsState();
}

class _TimePeriodChipsState extends State<TimePeriodChips> {
  TIMEPERIODS selection;

  @override
  void initState() {
    super.initState();
    this.selection = widget.initialSelection;
  }

  _onPeriodSelection (TIMEPERIODS period){
    setState(() {
      this.selection = period;
      widget.onPeriodSelected(period);
    });
  }

  Widget _buildChip(String label, TIMEPERIODS period) {
    return GestureDetector(
      onTap: () => _onPeriodSelection(period),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: (selection == period)
              ? Colors.black
              : Theme.of(context).chipTheme.backgroundColor,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.body1.copyWith(
                color: (selection == period) ? Colors.white : Colors.black,
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
          _buildChip('total', TIMEPERIODS.total),
          _buildChip('week', TIMEPERIODS.week)
        ],
      ),
    );
  }
}