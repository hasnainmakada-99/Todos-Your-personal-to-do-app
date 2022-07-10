import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todoapp/constants/routes.dart';
import 'package:todoapp/extnsions/get_arguments.dart';
import 'package:todoapp/services/auth/auth_services.dart';
import 'package:todoapp/services/cloud/cloud_note.dart';
import 'package:todoapp/services/cloud/firebase_cloud__storage.dart';

typedef NoteCallBack = void Function(CloudNote note);

class AddUpdateNotes extends StatefulWidget {
  const AddUpdateNotes({Key? key}) : super(key: key);

  @override
  State<AddUpdateNotes> createState() => _AddUpdateNotesState();
}

class _AddUpdateNotesState extends State<AddUpdateNotes> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController controller;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    controller = TextEditingController();
    super.initState();
  }

  // void textControllerListener() async {
  //   final note = _note;
  //   if (note == null) {
  //     return;
  //   } else {
  //     final text = controller.text;
  //     await _notesService.updateNotes(
  //       documentId: note.documentId,
  //       text: text,
  //     );
  //   }
  // }

  // void SetUptextcontrollerListener() async {
  //   controller.removeListener(textControllerListener);
  //   controller.addListener(textControllerListener);
  // }

  // Future<CloudNote> createOrGetexistingNotes(BuildContext context) async {
  //   final widgetNote = context.getArgument<CloudNote>();

  //   if (widgetNote != null) {
  //     _note = widgetNote;
  //     controller.text = widgetNote.text;
  //     return widgetNote;
  //   }

  //   final existingNote = _note;
  //   if (existingNote != null) {
  //     return existingNote;
  //   } else {
  //     final currentUser = AuthService.firebase().currentUser!;
  //     final userId = currentUser.id;
  //     final newNote = _notesService.createNewNote(ownerUserId: userId);
  //     _note = await newNote;
  //     return newNote;
  //   }
  // }

  // void deleteNoteIfTextEmpty() {
  //   final note = _note;
  //   if (controller.text.isEmpty && note != null) {
  //     _notesService.deleteNote(documentId: note.documentId);
  //   }
  // }

  // void saveNoteIfTextNotEmpty() async {
  //   final note = _note;
  //   final text = controller.text;
  //   if (note != null && text.isNotEmpty) {
  //     await _notesService.updateNotes(
  //       documentId: note.documentId,
  //       text: text,
  //     );
  //   }
  // }

  @override
  void dispose() {
    // deleteNoteIfTextEmpty();
    // saveNoteIfTextNotEmpty();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Add Your Notes',
          style: TextStyle(fontFamily: 'Fredoka'),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(24, 151, 143, 20),
      ),
      body: Column(
        children: [
          Container(
            width: 500,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(25),
                color: const Color.fromARGB(255, 255, 255, 255)),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(fontFamily: 'Fredoka'),
                  decoration: InputDecoration(
                      hintText: 'Start typing your note',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25))),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: 90,
                    child: TextButton(
                      onPressed: () async {
                        final user_Id = AuthService.firebase().currentUser!.id;

                        if (controller.text.isEmpty) {
                          const snackbar = SnackBar(
                            content: Text('You cannot add empty notes!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        } else {
                          final note = controller.text;
                          _notesService.createNewNote(
                            ownerUserId: user_Id,
                            text: note,
                          );

                          Navigator.of(context).pushNamedAndRemoveUntil(
                            notesRoute,
                            (route) => false,
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 116, 146, 170),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 22,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      // default:
      //   return const Center(child: CircularProgressIndicator());
    );
  }
}
