import 'package:supabase_flutter/supabase_flutter.dart';

class NoteDb {
  final database = Supabase.instance.client.from("notes");

  //create
  Future<void> creatNote(String note) async {
    await database.insert({'content': note});
  }

  //update
  Future<void> updateNote(dynamic noteid, String updatedNote) async {
    await database.update({'content': updatedNote}).eq('id', noteid);
  }

  //delete
  Future<void> deletenote(dynamic noteid) async {
    await database.delete().eq('id', noteid);
  }
}
