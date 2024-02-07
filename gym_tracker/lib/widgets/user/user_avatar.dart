import 'dart:io';

import 'package:flutter/material.dart';

class UserAvatar extends StatefulWidget {
  String image;
  double radius;

  UserAvatar({@required this.image, @required this.radius});

  @override
  _UserAvatarState createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  
  @override
  Widget build(BuildContext context) {
    
    return Container(
      alignment: Alignment.center,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: widget.radius,
        backgroundImage: Image.asset(
          (widget.image != null && widget.image.isNotEmpty)
              ? widget.image
              : 'lib/images/myAvatar.png',
          fit: BoxFit.cover,
        ).image,
      ),
    );
  }
}
