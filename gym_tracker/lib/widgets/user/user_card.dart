import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/models/utils/unit.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:gym_tracker/widgets/user/user_avatar.dart';
import 'package:provider/provider.dart';

class UserCard extends StatelessWidget {
  UserProvider user;
  var viewSize;

  Widget _buildAvatar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: UserAvatar(
        image: user.image,
        radius: 30, 
      ),
    );
  }

  Widget _buildUserInfo(context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AutoSizeText(
            (user.name != null) ? user.name : 'Guest User',
            style: Theme.of(context).textTheme.title,
            maxLines: 1,
          ),
          AutoSizeText(
            (user.weightsList.length > 0 && user.height != null)
                ? '${user.currWeight.toStringAsFixed(0)} ${Unit.mapToStr(user.weightUnit)}, ${user.height.toStringAsFixed(0)} ${Unit.mapToStr(user.heightUnit)}'
                : 'edit',
            style: (user.weightsList.length > 0 && user.height != null)
                ? Theme.of(context).textTheme.subtitle
                : Theme.of(context).textTheme.subtitle.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
            maxLines: 1,
          ),
        ],
    );
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    viewSize = MediaQuery.of(context).size;

    return Card(
      child: Row(
        children: [
        Expanded( 
          child: _buildAvatar(),
          flex: 1,
        ),
        Expanded(
          flex: 2,
          child: _buildUserInfo(context)
        ),
      ]),
    );
  }
}
