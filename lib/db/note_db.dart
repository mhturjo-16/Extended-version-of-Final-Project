import 'package:supabase_flutter/supabase_flutter.dart';

class NoteDb {
  final supabase = Supabase.instance.client;
  final table = 'notes';

  // Create
  Future<void> createNote(String note) async {
    await supabase.from(table).insert({'content': note});
  }

  // Read all notes
  Future<List<Map<String, dynamic>>> getNotes() async {
    final response = await supabase.from(table).select();
    return List<Map<String, dynamic>>.from(response);
  }

  // Update
  Future<void> updateNote(int id, String updatedNote) async {
    await supabase.from(table).update({'content': updatedNote}).eq('id', id);
  }

  // Delete
  Future<void> deleteNote(int id) async {
    await supabase.from(table).delete().eq('id', id);
  }
}
