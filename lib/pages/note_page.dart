import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/note_db.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final noteContoller = TextEditingController();
  final noteDb = NoteDb();
  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add note"),
        content: TextField(controller: noteContoller),

        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteContoller.clear();
            },
            child: Text("Cancel"),
          ),

          // Save Button
          TextButton(
            onPressed: () async {
              final newNote = noteContoller.text;
              try {
                await noteDb.createNote(newNote);
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Note inserted")));
                }
                Navigator.pop(context);

                //noteContoller.clear();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: Icon(Icons.add),
      ),
    );
  }
}
