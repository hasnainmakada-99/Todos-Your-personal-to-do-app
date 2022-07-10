import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Future<bool> delete_dialog(BuildContext context) {
    return showDialog(
    context: context, 
    builder: (context){
        return AlertDialog(
          title: const Text('Are you sure you want to delete the note'),
          actions: [
            TextButton(onPressed: (){}, child: const Text('Yes')),
            TextButton(onPressed: (){}, child: const Text('No'))
          ],
        );
    }

    ).then((value) => value ?? false);
}