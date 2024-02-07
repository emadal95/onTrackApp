import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/navigation_icons.dart';
import 'package:gym_tracker/models/utils/unit.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/set.dart';

class WeightDropdown extends StatefulWidget {
  Function onChanged;
  String label;
  WeightDropdown({this.onChanged, this.label});

  _WeightDropdownState createState() => _WeightDropdownState();
}

class _WeightDropdownState extends State<WeightDropdown> {
  var _selectedWeight;

  void _onWeightSelected(var selection) {
    setState(() {
      _selectedWeight = selection;
      widget.onChanged(selection);
    });
  }

  Widget get dropdownSuffix {
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: Row(children: [
        Icon(NavigationIcons.chevron_down, size: 12),
        SizedBox(
          width: 5,
        ),
        Text(Unit.mapToStr(Provider.of<UserProvider>(context).weightUnit)),
      ]),
    );
  }

  List<DropdownMenuItem> get dropdownItems {
    return Set.generateListOfLiftingWeights(start: 5, max: 800, interval: 5)
        .map(
          (double weight) => DropdownMenuItem(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  weight.toStringAsFixed(2),
                ),
              ),
            ),
            value: weight,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: <Widget>[
          AutoSizeText(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption.copyWith(
                  //fontSize: Theme.of(context).textTheme.body1.fontSize,
                  color: Theme.of(context).hintColor,
                ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).hintColor, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton(
              hint: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  'select weight',
                  style: Theme.of(context).textTheme.caption.copyWith(
                      //fontSize: Theme.of(context).textTheme.body1.fontSize
                      ),
                ),
              ),
              icon: dropdownSuffix,
              style: Theme.of(context).textTheme.subhead,
              underline: Padding(
                padding: EdgeInsets.all(0),
              ), //to disable underline
              isExpanded: false,
              items: dropdownItems,
              onChanged: (weight) => _onWeightSelected(weight),
              value: _selectedWeight,
            ),
          ),
        ],
      ),
    );
  }
}
