import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showLoadingDialog(
    {required BuildContext context, required String text}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 10.0),
        Text(text),
      ],
    ),
  );

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => dialog,
  );
}
