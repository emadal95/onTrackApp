import 'package:flutter/material.dart';

class PrimaryColorDivider extends StatelessWidget {
  double height;

  PrimaryColorDivider(this.height);

  @override
  Widget build(BuildContext context) {
    return Divider(height: this.height, color: Theme.of(context).primaryColor, thickness: 1,);
  }
}