import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> emptyDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cannot Share Empty Dialog'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            )
          ],
        );
      });
}
