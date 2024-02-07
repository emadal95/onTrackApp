import 'package:flutter/material.dart';

class Dialogs {
  BuildContext context;

  Dialogs(this.context);

  Future onSaveSessionDialog({Function onSave}) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Save and end session?"),
          actions: <Widget>[
            FlatButton(
              onPressed: onSave,
              child: const Text("SAVE"),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("CANCEL"),
            ),
          ],
        );
      },
    );
  }

  Future onCancelSessionDialog({Function onQuit}) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Quit session?"),
          actions: <Widget>[
            FlatButton(
              onPressed: onQuit,
              child: const Text("QUIT"),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("CANCEL"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> confirmRemoveDialog(DismissDirection dismissDirection) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text("Confirm action"),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("DELETE"),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("CANCEL"),
            ),
          ],
        );
      },
    );
  }
}
