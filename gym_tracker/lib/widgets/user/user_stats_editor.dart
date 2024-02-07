import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/database/app_db.dart';
import 'package:gym_tracker/database/query_helper.dart';
import 'package:gym_tracker/icons/tabs_icons.dart';
import 'package:gym_tracker/models/utils/unit.dart';
import 'package:gym_tracker/providers/user_provider.dart';

class UserStatsEditor extends StatefulWidget {
  var viewSize;
  UserProvider user;
  UserStatsEditor(this.viewSize, this.user);

  _UserStatsEditorState createState() => _UserStatsEditorState();
}

class _UserStatsEditorState extends State<UserStatsEditor> {
  FocusNode _keyboardFocusNode;
  FocusNode weightInputFocusNode;
  var _statsFormEntries;
  final double extendedHeightFraction = 0.90;
  final double collapsedHeightFraction = 0.5;
  var heightScaleFactor;

  @override
  void initState() {
    _keyboardFocusNode = new FocusNode()..addListener(_keyboardListener);
    heightScaleFactor = extendedHeightFraction;
    weightInputFocusNode = new FocusNode();
  }

  void collapse() {
    setState(() {
      heightScaleFactor = collapsedHeightFraction;
    });
  }

  void extend() {
    setState(() {
      heightScaleFactor = extendedHeightFraction;
    });
  }

  void _keyboardListener() {
    if (_keyboardFocusNode.hasFocus)
      collapse();
    else
      extend();
  }

  void saveHeight(height) {
    widget.user.setHeight(height, widget.user.heightUnit);
  }

  void saveWeight(newWeight) {
    var date = DateTime.now();
    widget.user.addWeight(newWeight, widget.user.weightUnit, date);
    _saveWeightToDb(newWeight, date);
  }

  Future _saveWeightToDb(newWeight, date) async {
    var data =
        QueryHelper.toQueryWeightData(newWeight, widget.user.weightUnit, date);
    return await AppDatabase().insertWeight(data);
  }

  Widget _buildHeader(text, topPadding) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: Container(
        padding: EdgeInsets.only(top: topPadding),
        child: AutoSizeText(text, style: Theme.of(context).textTheme.title),
      ),
    );
  }

  String entryNumberValidator(value) {
    if (double.tryParse(value) != null)
      return null;
    else
      return 'Only numbers';
  }

  Widget get weightEntry {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        autovalidate: true,
        autocorrect: false,
        focusNode: weightInputFocusNode,
        validator: (value) => (value.isEmpty || double.tryParse(value) != null)
            ? null
            : 'Please, use numbers only',
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (newWeight) => saveWeight(double.parse(newWeight)),
        initialValue: (widget.user.weightsList.length > 0)
            ? widget.user.weightsList.last.toStringAsFixed(0)
            : null,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          suffix: Text(
            Unit.mapToStr(widget.user.weightUnit),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          suffixIcon: Icon(
            TabsIcons.resize_small_alt,
            size: 15,
            color: Theme.of(context).primaryColor,
          ),
          labelText: 'Current weight',
        ),
      ),
    );
  }

  Widget get heightEntry {
    return TextFormField(
      autovalidate: true,
      autocorrect: false,
      validator: (value) => (value.isEmpty || double.tryParse(value) != null)
          ? null
          : 'Please, use numbers only',
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (newHeight) {
        saveHeight(double.parse(newHeight));
        FocusScope.of(context).requestFocus(weightInputFocusNode);
      },
      initialValue: (widget.user.height != null)
          ? widget.user.height.toStringAsFixed(0)
          : null,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        suffix: Text(
          Unit.mapToStr(widget.user.heightUnit),
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        suffixIcon: Icon(TabsIcons.resize_vertical, size: 15, color: Theme.of(context).primaryColor),
        labelText: 'Height',
      ),
    );
  }

  /*Widget get listOfWeights {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (ctx, i) => WeightCard(
            user: widget.user, i: (widget.user.userWeightsList.length - 1) - i),
        itemCount: widget.user.userWeightsList.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 1/2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
        ),
        physics: ScrollPhysics(),
        
      ),
    );
  }*/

  /*Widget get weightsListLabel {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Text(
        'Weight logs',
        style: Theme.of(context).textTheme.caption,
        textAlign: TextAlign.left,
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    /*_statsFormEntries = [
      Flexible(flex: 1, child: heightEntry),
      Flexible(flex: 1, child: weightEntry),
      Flexible(flex: 1, child: weightsListLabel),
      Expanded(child: listOfWeights),
    ];*/

    return Column(
      //direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: _buildHeader('Stats', 20.0),
        ),
        Expanded(
          flex: 12,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: ListView(
              children: <Widget>[
                heightEntry,
                weightEntry,
                //weightsListLabel,
                //listOfWeights,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
