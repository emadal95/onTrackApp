import 'package:flutter/material.dart';
import 'package:gym_tracker/models/utils/human_body.dart';

class BodyPartsPicker extends StatefulWidget {
  Function onBodyPartTapped;
  List<BODYPARTS> bodyPartsSelected;

  BodyPartsPicker({this.onBodyPartTapped, this.bodyPartsSelected});

  _BodyPartsPickerState createState() => _BodyPartsPickerState();
}

class _BodyPartsPickerState extends State<BodyPartsPicker> {
  void _onBodyPartPicked(bPart) {
    widget.onBodyPartTapped(bPart);
  }

  Widget _getIconContainer(
      IconData icon, BODYPARTS bPart, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: 5, left: 1),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: (widget.bodyPartsSelected.contains(bPart))
              ? Theme.of(context).accentColor
              : Theme.of(context).backgroundColor,
          width: 2
        ),
      ),
      child: InkWell(
        onTap: () => _onBodyPartPicked(bPart),
        child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _getIconLabel(String title, BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }

  Widget _buildBodyPartIcon(BODYPARTS bPart) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _getIconContainer(HumanBody.mapToIcon(bPart), bPart, context),
        _getIconLabel(HumanBody.mapPartToString(bPart), context)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) => _buildBodyPartIcon(BODYPARTS.values[i]),
        itemCount: BODYPARTS.values.length,
      ),
    );
  }
}
