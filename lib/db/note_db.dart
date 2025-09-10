import 'package:supabase_flutter/supabase_flutter.dart';

class NoteDb {
  final supabase = Supabase.instance.client;
  final String table = 'data';

  // ✅ Create note (content only)
  Future<void> createNote(String content) async {
    await supabase.from(table).insert({'content': content});
  }

  // ✅ Get all notes (all users, for debugging)
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final response = await supabase.from(table).select();
    return List<Map<String, dynamic>>.from(response);
  }

  // ✅ Get notes for current user (if your table had user_id)
  // Since your table only has 'content', we fetch all
  Future<List<Map<String, dynamic>>> getUserNotes() async {
    final response = await supabase.from(table).select();
    return List<Map<String, dynamic>>.from(response);
  }

  // ✅ Update note by id
  Future<void> updateNote(int id, String content) async {
    await supabase.from(table).update({'content': content}).eq('id', id);
  }

  // ✅ Delete note by id
  Future<void> deleteNote(int id) async {
    await supabase.from(table).delete().eq('id', id);
  }
}
