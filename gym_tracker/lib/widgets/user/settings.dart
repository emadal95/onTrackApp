import 'package:flutter/material.dart';
import 'package:gym_tracker/database/app_db.dart';
import 'package:gym_tracker/models/utils/unit.dart';
import 'package:gym_tracker/models/user.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  UserProvider user;
  var didLoad = false;
  Map<UNITS, bool> heightUnits = {
    UNITS.INCH: false,
    UNITS.CM: false,
  };

  Map<UNITS, bool> weightUnits = {UNITS.LB: false, UNITS.KG: false};

  void _initVars() {
    if(!didLoad){
      heightUnits[user.heightUnit] = true;
      weightUnits[user.weightUnit] = true;
      didLoad = true;
    }
  }

  @override
  void dispose(){
    _saveChangesToDB();

    super.dispose();
  }

  _saveChangesToDB() async {
    AppDatabase().updateUserInfo({
      'id': user.id,
      'height_unit': Unit.mapToStr(user.heightUnit),
      'weight_unit': Unit.mapToStr(user.weightUnit),
    });
  }

  void _onSelectHeight(unitId) {
    setState(() {
      heightUnits.forEach((unit, selected) => heightUnits[unit] = false);
      heightUnits[unitId] = true;
      user.setHeightUnit(unitId);
    });
  }

  void _onSelectWeigth(unitId) {
    setState(() {
      weightUnits.forEach((unit, selected) => weightUnits[unit] = false);
      weightUnits[unitId] = true;
      user.setWeightUnit(unitId);
    });
  }

  Widget _buildHeader(text, topPadding) {
    return Container(
      padding: EdgeInsets.only(top: topPadding, left: 10),
      child: Text(text),
    );
  }

  Widget _buildSelectionTile(title, key, callBackFn, units) {
    return InkWell(
      onTap: () => callBackFn(key),
      child: ListTile(
        leading: Text(title),
        trailing: (units[key])
            ? Icon(
                Icons.check,
                color: Colors.green,
              )
            : null,
      ),
    );
  }

  Widget _buildSection(sectionTitle, firstTileTitle, secondTileTitle, key1,
      key2, callBackFn, units) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(sectionTitle, 10.0),
          Divider(
            indent: 10,
          ),
          _buildSelectionTile(firstTileTitle, key1, callBackFn, units),
          _buildSelectionTile(secondTileTitle, key2, callBackFn, units)
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    _initVars();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader('Pick your measurement units', 20.0),
          SizedBox(
            height: 10,
          ),
          _buildSection('Height', 'Imperial', 'Metric', UNITS.INCH, UNITS.CM,
              _onSelectHeight, heightUnits),
          SizedBox(
            height: 10,
          ),
          _buildSection('Weight', 'Pounds', 'Kilograms', UNITS.LB, UNITS.KG,
              _onSelectWeigth, weightUnits)
        ],
      ),
    );
  }
}
