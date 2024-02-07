import 'package:flutter/material.dart';
import 'package:gym_tracker/widgets/customs/primary_color_divider.dart';

class CardWithHeader extends StatefulWidget {
  Widget child;
  Widget header;
  double height;
  CardWithHeader({this.header, this.child, this.height});

  @override
  _CardWithHeaderState createState() => _CardWithHeaderState();
}

class _CardWithHeaderState extends State<CardWithHeader> {

  Widget _buildContentColumn() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(flex: 1, child: widget.header),
          PrimaryColorDivider(20),
          Expanded(flex: 8, child: widget.child)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        height: widget.height,
        padding: EdgeInsets.all(14),
        child: _buildContentColumn(),
      ),
    );
  }
}