//note_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/note_db.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final noteController = TextEditingController();
  final noteDb = NoteDb();

  // Show dialog to add a new note
  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Note"),
        content: TextField(controller: noteController),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final newNote = noteController.text.trim();
              if (newNote.isEmpty) return;

              try {
                await noteDb.createNote(newNote);
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Note added")));
                }
                noteController.clear();
                Navigator.pop(context);
                setState(() {}); // Refresh the list to show new note
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

  // Fetch all notes from database
  Future<List<Map<String, dynamic>>> fetchNotes() async {
    try {
      return await noteDb.getAllNotes();
    } catch (e) {
      print("Error fetching notes: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error loading notes"));
          }

          final notes = snapshot.data ?? [];

          if (notes.isEmpty) {
            return Center(child: Text("No notes yet"));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index]['content'] ?? '';
              return ListTile(title: Text(note));
            },
          );
        },
      ),
    );
  }
}
