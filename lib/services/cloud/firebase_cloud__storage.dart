import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../cloud/cloud_constants.dart';
import '../cloud/cloud_exceptions.dart';
import '../cloud/cloud_note.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  // Fetches all the notes and displays accordingly the userId
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    final allNotes = notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }

  Future createNewNote(
      {required String ownerUserId, required String text}) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: text,
    });

    // final fetchedNote = await document.get();

    // return CloudNote(
    //   documentId: fetchedNote.id,
    //   ownerUserId: ownerUserId,
    //   text: '',
    // );
  }

  Future<void> updateNotes({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNotesException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNotesException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;
}
