import 'dart:convert';
import 'package:notes_app/models/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteService {
  static const String _key = 'saved_notes';

  static Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString(_key);

    if (notesString == null) return [];

    final List<dynamic> decodedData = jsonDecode(notesString);
    return decodedData.map((item) => Note.fromMap(item)).toList();
  }

  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      notes.map((note) => note.toMap()).toList(),
    );
    await prefs.setString(_key, encodedData);
  }

  static Future<void> addNote(Note newNote) async {
    final List<Note> currentNotes = await getNotes();
    currentNotes.add(newNote);
    await saveNotes(currentNotes);
  }

  static Future<void> deleteNote(Note noteToDelete) async {
    final List<Note> currentNotes = await getNotes();

    currentNotes.removeWhere((note) =>
      note.title == noteToDelete.title &&
      note.updatedAt == noteToDelete.updatedAt
    );

    await saveNotes(currentNotes);
  }
}