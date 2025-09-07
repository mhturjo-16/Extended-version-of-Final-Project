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



/*
import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/note_db.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => NotePage();
}

class NotePage extends State<NotePage> {
  final noteContoller = TextEditingController();
  final noteDb = NoteDatabase();

  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("New Note"),
        content: TextField(
          controller: noteContoller,
        ),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Note inserted: $newNote")),
                  );
                }
                Navigator.pop(context); 
                noteContoller.clear();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void updateNote(dynamic notedi,String oldNote)
  {
    noteContoller.text = oldNote?? "";
    showDialog(
      context: context, 
      builder: (context)=> AlartDialog
      (
        Title:Text("Updated Note"),
        content: TextField(
          controller: noteContoller,
        ),
        Actions:
        [
          TextButton(onPressed: (){Navigator.pop(context);
          noteContoller.clear();
          }, 
          child: Text("Cancle")),
          TextButton(onPressed: ()async
          {
           try{
            final updateNote = noteController.text;
            await NoteDb.updateNote(id,)
           }
          }, 
          child: Text("Update")),
        ],
      )
      )
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: noteDb.database.stream(primarykey:['id']), 
        builder: (context,snapshot)
        {
          if(!snapshot.hasData)
          {
            return CircularProgressIndicator();
          }
          final notes=snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context,index){
              final note =notes[index!] ;
              final id=note['id'];
              final content = note['content'];

              return Card(
                child: ListTile(
                  title: Text(content),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: 
                  [
                    IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
                    IconButton(onPressed: (){updateNote(id,content);}, icon: Icon(Icons.edit)),
                  ],),
                ),
              );
             },
          );
        }
        ),
    );
  }
}

*/