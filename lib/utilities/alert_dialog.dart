
 import 'package:flutter/material.dart';

Future<bool> showlogoutDialog(BuildContext context){
    return showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: const Text('Sign out'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              }, 
              child: const Text('Cancel')
              ),
              
          ],
        );
      },
      ).then((value) => value ?? false);
}
