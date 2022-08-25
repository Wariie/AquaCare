import 'package:flutter/material.dart';

class CustomDialog {
  static Future<bool> showConfirmationDialog(
      BuildContext context, String title, String description) async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(title),
              content: Text(description),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Ok'),
                  child: const Text('Ok'),
                ),
              ],
            ));
    if (result as String == "Ok") {
      return true;
    }
    return false;
  }

  static menuDialog(
    BuildContext context,
    String title,
  ) {
    var r = showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
                contentPadding: const EdgeInsets.all(8.0),
                title: const Text("Edit Detail - "),
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context, ['Save']);
                    },
                    child: const Text('Save'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                ]));
  }
}
