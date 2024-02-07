import 'package:flutter/material.dart';

class DismissibleBackground {
  BuildContext context;

  DismissibleBackground(this.context);

  Widget get delete {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding:
              EdgeInsets.only(right: (MediaQuery.of(context).size.width / 5)),
          child: Icon(
            Icons.delete,
            color: Colors.redAccent,
            size: 30,
          ),
        ),
      ),
    );
  }

}