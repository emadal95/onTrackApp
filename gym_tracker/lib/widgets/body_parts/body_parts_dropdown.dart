import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/tools_icons.dart';
import 'package:gym_tracker/models/utils/human_body.dart';

class BodyPartsDropdown extends StatefulWidget {
  Function onPartSelected;
  List<BODYPARTS> partsToDisplay;

  BodyPartsDropdown({this.onPartSelected, this.partsToDisplay});

  @override
  _BodyPartsDropdownState createState() => _BodyPartsDropdownState();
}

class _BodyPartsDropdownState extends State<BodyPartsDropdown> {
  BODYPARTS _partSelected;

  onPartSelected(selection) {
    setState(() {
      _partSelected = selection;
      widget.onPartSelected(selection);
    });
  }

  List<DropdownMenuItem> get bodypartDropdownItems {
    return widget.partsToDisplay
        .map(
          (part) => DropdownMenuItem(
            value: part,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(HumanBody.mapToIcon(part)),
                SizedBox(width: 20),
                AutoSizeText(HumanBody.mapPartToString(part)),
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_partSelected == null && widget.partsToDisplay.length > 0) _partSelected = widget.partsToDisplay[0];

    return DropdownButton(
      iconSize: 14,
      icon: Icon(ToolsIcons.chevron_down_circle),
      isExpanded: true,
      underline: Padding(
        padding: EdgeInsets.all(0),
      ), //to disable underline
      items: bodypartDropdownItems,
      onChanged: (selection) => onPartSelected(selection),
      value: _partSelected,
    );
  }
}
