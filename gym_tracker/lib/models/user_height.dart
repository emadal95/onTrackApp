import 'package:flutter/foundation.dart';
import '../models/height.dart';

class UserHeight {
  String id;
  Height height;

  UserHeight({
    @required this.id,
    this.height
  });
}
