import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/workout_icons.dart';

class IconPicker extends StatefulWidget {
  Function onIconChanged;
  List<IconData> availableIcons;
  IconData selectedIcon;

  IconPicker({this.onIconChanged, @required this.availableIcons, this.selectedIcon});

  _IconPickerState createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  IconData selectedIcon;
  List<IconData> availableIcons;

  @override
  initState(){
    availableIcons = widget.availableIcons;
    selectedIcon = (widget.selectedIcon == null) ? availableIcons[0] : widget.selectedIcon;
  }

  onIconSelected(iconData){
    widget.onIconChanged(newIcon: iconData);
    selectedIcon = iconData;
  }

  Widget _circularIconOption(iconData, i) {
    return Container(
      margin: EdgeInsets.only(right: 5, left: 1),
      child: GestureDetector(
        onTap: () => onIconSelected(iconData),
        child: CircleAvatar(
          child: Icon(
            iconData,
            color: Colors.white,
          ),
          backgroundColor: (iconData.codePoint == selectedIcon.codePoint)
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor),
            top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (ctx, i) => _circularIconOption(availableIcons[i], i),
        itemCount: availableIcons.length,
      ),
    );
  }
}
