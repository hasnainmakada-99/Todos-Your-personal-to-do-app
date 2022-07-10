import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todoapp/services/auth/auth_services.dart';
import 'package:todoapp/services/cloud/cloud_note.dart';
import 'package:todoapp/services/cloud/firebase_cloud__storage.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatefulWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onTap,
  }) : super(key: key);

  @override
  State<NotesListView> createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  late final FirebaseCloudStorage _notesService;
  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notes.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: const Text(
          'No Notes here tap + to add Notes',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
            fontFamily: 'Fredoka',
          ),
        ),
      );
    }
    return SizedBox(
      child: ListView.builder(
        itemCount: widget.notes.length,
        itemBuilder: (context, index) {
          final note = widget.notes.elementAt(index);
          return ListTile(
            onTap: () async {
              updateNotes(context, note.documentId, note.text, index);
            },
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: 'Fredoka', fontSize: 22),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    setState(() {
                      final delete = showdeleteDialog(context, index);
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
                IconButton(
                    onPressed: () {
                      Share.share(note.text);
                    },
                    icon: const Icon(Icons.share))
              ],
            ),
          );
        },
      ),
    );
  }

  Future<CloudNote> showdeleteDialog(BuildContext context, index) {
    final note = widget.notes.elementAt(index);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure you want to delete this note ?"),
          actions: [
            TextButton(
              onPressed: () async {
                final delete =
                    _notesService.deleteNote(documentId: note.documentId);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  Future<bool> updateNotes(
      BuildContext context, String documentId, String text, index) {
    TextEditingController controller = TextEditingController();
    final note = widget.notes.elementAt(index);
    controller.text = note.text;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Edit',
            style:
                TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.bold),
          ),
          actions: [
            TextField(
              controller: controller,
              maxLines: null,
            ),
            TextButton(
              onPressed: () async {
                if (controller.text.isEmpty) {
                  final snackBar =
                      SnackBar(content: const Text('Cannot Save empty note'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  await _notesService.updateNotes(
                    documentId: documentId,
                    text: controller.text,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            )
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
