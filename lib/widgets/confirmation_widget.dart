import 'package:flutter/material.dart';

Future<dynamic> confirmationDelete(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text('Confirmation'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Yes'),
            ),
          ],
        ),
  );
}
