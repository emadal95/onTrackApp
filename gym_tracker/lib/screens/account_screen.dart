import 'package:flutter/material.dart';
import 'package:gym_tracker/database/app_db.dart';
import 'package:gym_tracker/database/query_helper.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:gym_tracker/widgets/user/account.dart';
import 'package:gym_tracker/widgets/customs/floating_page.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  static final String routeName = '/account';
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserProvider user;

  Future _saveChangesToDb() async {
    var data = QueryHelper.toQueryUserData(user);
    return await AppDatabase().updateUserInfo(data);
  }

  @override
  void dispose(){
    _saveChangesToDb();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    var viewSize = MediaQuery.of(context).size;
  
    return FloatingPage(
      child: Container(
        width: viewSize.width - 40,
        height: viewSize.height - 60,
        child: Account(user, viewSize),
      ),
    );
  }
}
