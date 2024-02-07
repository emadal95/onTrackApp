import 'package:flutter/material.dart';

class TitleWithCard extends StatefulWidget {
  String title;
  String subtitle;
  Widget card;
  TitleWithCard(this.card, {this.title, this.subtitle});

  @override
  _TitleWithCardState createState() => _TitleWithCardState();
}

class _TitleWithCardState extends State<TitleWithCard> {
  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );

    TextStyle subtitleStyle = TextStyle(
      fontSize: 12,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          //contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          title: Text(widget.title, style: titleStyle),
          subtitle: Text(widget.subtitle, style: subtitleStyle),
        ),
        SizedBox(height: 10),
        widget.card
      ],
    );
  }
}