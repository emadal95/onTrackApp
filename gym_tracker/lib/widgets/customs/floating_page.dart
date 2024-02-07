import 'package:flutter/material.dart';

class FloatingPage extends StatefulWidget {
  Widget child;
  List<Widget> actions;
  String title;
  FloatingPage({this.child, this.actions, this.title}) {}

  @override
  _FloatingPageState createState() => _FloatingPageState();
}

class _FloatingPageState extends State<FloatingPage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      title: (widget.title != null)
          ? Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(top: 10),
              child: Center(child: Text(widget.title, style: Theme.of(context).textTheme.display1,)),
            )
          : null,
      titlePadding: EdgeInsets.all(0),
      titleTextStyle: Theme.of(context)
          .appBarTheme
          .textTheme
          .title
          .copyWith(color: Theme.of(context).primaryColor),
      actions: widget.actions,
      elevation: 3,
      backgroundColor: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      content: widget.child,
    );
  }
}
