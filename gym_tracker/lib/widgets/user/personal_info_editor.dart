import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:gym_tracker/icons/gender_icons.dart';

class PersonalInfoEditor extends StatefulWidget {
  var viewSize;
  UserProvider user;
  PersonalInfoEditor(this.viewSize, this.user);

  _PersonalInfoEditorState createState() => _PersonalInfoEditorState();
}

class _PersonalInfoEditorState extends State<PersonalInfoEditor> {
  FocusNode _keyboardFocusNode;
  FocusNode dobInputFocusNode;
  final double extendedHeightFraction = 0.85;
  final double collapsedHeightFraction = 0.5;
  TextEditingController birthdayController;
  var heightScaleFactor;
  var _personalInfoFormEntries;
  var _selectedGender;

  @override
  void initState() {
    _keyboardFocusNode = new FocusNode()..addListener(_keyboardListener);
    heightScaleFactor = extendedHeightFraction;
    dobInputFocusNode = new FocusNode();
  }

  @override
  void dispose(){
    _keyboardFocusNode.dispose();
    dobInputFocusNode.dispose();
    birthdayController.dispose();
    
    super.dispose();
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

  void _onNameChanged(name) {
    widget.user.setName(name);
  }

  _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      minDateTime: DateTime(1900),
      maxDateTime: DateTime.now(),
      initialDateTime: DateTime(2000),
      dateFormat: 'dd-MMM-yyyy',
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(
          'Save',
          style: Theme.of(context)
              .textTheme
              .subhead
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      pickerMode: DateTimePickerMode.date,
      onConfirm: (dateTime, List<int> index) {
        print(dateTime);
        print(index);
        widget.user.setBirthday(dateTime);
        print('unfocusing');
      },
    );
  }

  Widget get nameEntry {
    return TextFormField(
      focusNode: _keyboardFocusNode,
      initialValue: (widget.user.name != null) ? widget.user.name : null,
      onFieldSubmitted: (newName) {
        _onNameChanged(newName);
        FocusScope.of(context).requestFocus(dobInputFocusNode);
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      autocorrect: false,
      autofocus: false,
      maxLines: 1,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        suffixIcon: Icon(Icons.edit, size: 15, color: Theme.of(context).primaryColor,),
        labelText: 'Name',
        labelStyle: TextStyle(color: Colors.grey)
      ),
    );
  }

  Widget get birthdayEntry {
    print('rebuilt');
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: InkWell(
        onTap: _showDatePicker,
        child: TextFormField(
          enabled: false,
          readOnly: true,
          focusNode: dobInputFocusNode,
          controller: birthdayController,
          decoration: InputDecoration(
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            suffixIcon: Icon(
              Icons.calendar_today,
              size: 15,
              color: Theme.of(context).primaryColor,
            ),
            labelText: 'Birthday',
          ),
        ),
      ),
    );
  }

  void _onGenderSelection(selection) {
    setState(() {
      _selectedGender = selection;
    });
    widget.user.setGender(_selectedGender);
  }

  Widget _buildGenderChip(String label, IconData icon) {
    return GestureDetector(
      onTap: () => _onGenderSelection(label),
      child: Chip(
        backgroundColor:
            (label == _selectedGender) ? Theme.of(context).primaryColor : null,
        avatar: Icon(
          icon,
          size: 20,
          color: (label == _selectedGender) ? Colors.white : Colors.black54,
        ),
        label: Text(
          label,
          style: Theme.of(context).textTheme.subhead.copyWith(
              color:
                  (label == _selectedGender) ? Colors.white : Colors.black54),
        ),
      ),
    );
  }

  Widget get genderEntry {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildGenderChip('Male', GenderIcons.male),
          _buildGenderChip('Female', GenderIcons.female)
        ],
      ),
    );
  }

  Widget _buildHeader(text, topPadding) {
    return Container(
      padding: EdgeInsets.only(top: topPadding),
      child: AutoSizeText(text, style: Theme.of(context).textTheme.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    _selectedGender = widget.user.gender;
    birthdayController = TextEditingController(
      text: (widget.user.birthday != null)
          ? DateFormat.yMMMd().format(widget.user.birthday)
          : null,
    );
    _personalInfoFormEntries = [nameEntry, birthdayEntry, genderEntry];

    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: _buildHeader('Personal information', 20.0),
        ),
        Flexible(
          flex: 5,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: ListView.builder(
              shrinkWrap: false,
              itemBuilder: (ctx, i) => _personalInfoFormEntries[i],
              itemCount: _personalInfoFormEntries.length,
            ),
          ),
        ),
      ],
    );
  }
}
