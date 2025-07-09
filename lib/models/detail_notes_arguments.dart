import 'package:notes_app/models/notes.dart';

class DetailNotesArguments {
  final List<Notes> notes;
  final String? idEditNote;

  DetailNotesArguments({required this.notes, this.idEditNote});
}
