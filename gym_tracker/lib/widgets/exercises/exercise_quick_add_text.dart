import 'package:flutter/material.dart';

class QuickAddText extends StatefulWidget {
  Function onSubmit;
  String pickedText;
  String pageTitle;
  String fieldName;
  String validationErrorMsg;
  bool needsValidation;

  QuickAddText(
      {@required this.onSubmit,
      @required this.pickedText,
      @required this.fieldName,
      @required this.pageTitle,
      this.validationErrorMsg,
      this.needsValidation = true,
  });

  @override
  _QuickAddTextState createState() => _QuickAddTextState();
}

class _QuickAddTextState extends State<QuickAddText> {
  GlobalKey<FormState> _form = new GlobalKey();
  FocusNode equipFocusNode = new FocusNode();

  @override
  void dispose() {
    equipFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              alignment: Alignment.bottomLeft,
              child: Text(
                widget.pageTitle,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Form(
              key: _form,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: TextFormField(
                      autocorrect: false,
                      autofocus: (widget.needsValidation && widget.pickedText.isEmpty) ? true : false,
                      autovalidate: true,
                      maxLength: 20,
                      initialValue: widget.pickedText,
                      validator: (widget.needsValidation)
                          ? ((name) =>
                              (name.isEmpty) ? widget.validationErrorMsg : null)
                          : null,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (String newName) => {
                        if ((widget.needsValidation && newName.isNotEmpty) ||
                            (!widget.needsValidation))
                          widget.onSubmit(newName)
                      },
                      decoration: InputDecoration(
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          errorStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          labelText: widget.fieldName,
                          suffixIcon: Icon(
                            Icons.edit,
                            size: 15,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.circular(12)),
                          contentPadding: EdgeInsets.all(10)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
