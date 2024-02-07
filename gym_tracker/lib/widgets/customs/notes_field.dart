import 'package:flutter/material.dart';

class NotesField extends StatefulWidget {
  Function onNotesSubmitted;
  Function onRequestNotesFocus;
  String initialValue;

  NotesField({this.onNotesSubmitted, this.onRequestNotesFocus, this.initialValue});

  _NotesFieldState createState() => _NotesFieldState();
}

class _NotesFieldState extends State<NotesField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(10)),
      child: Card(
        margin: EdgeInsets.all(0),
        color: Theme.of(context).backgroundColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            initialValue: widget.initialValue,
            onTap: widget.onRequestNotesFocus,
            textAlign: TextAlign.left,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (notes) => widget.onNotesSubmitted(notes),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            maxLines: null,
          ),
        ),
      ),
    );
  }
}
