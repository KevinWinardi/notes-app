import 'dart:convert';

import 'package:notes_app/models/notes.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Notes>> getNotes() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final notesJSON = preferences.getString('notes');
  List<Notes> notes = [];

  if (notesJSON != null) {
    final List<dynamic> decodedNotes = jsonDecode(notesJSON);
    notes = decodedNotes.map((item) => Notes.fromJSON(item)).toList();
  }
  return notes;
}

Future<void> saveNotes(List<Notes> notes) async {
  final String notesJSON = jsonEncode(notes.map((n) => n.toJSON()).toList());
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('notes', notesJSON);
}
