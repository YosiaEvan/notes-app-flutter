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
}