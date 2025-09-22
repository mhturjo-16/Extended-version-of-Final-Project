//currency_converter_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/note_db.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final NoteDb noteDb = NoteDb();

  double result = 0;

  final Map<String, double> rates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.78,
    'JPY': 147.0,
    'BDT': 110.0,
  };

  final List<String> currencies = ['USD', 'EUR', 'GBP', 'JPY', 'BDT'];
  String fromCurrency = 'USD';
  String toCurrency = 'BDT';

  // 🔹 Currency convert function
  void convert() {
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) return;

    final usdAmount = amount / rates[fromCurrency]!;
    final converted = usdAmount * rates[toCurrency]!;

    setState(() {
      result = converted;
    });
  }

  // 🔹 Add new note
  void addNewNote() {
    noteController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Note"),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(hintText: "Write your note"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final newNote = noteController.text.trim();
              if (newNote.isNotEmpty) {
                try {
                  await noteDb.createNote(newNote);
                  if (mounted) setState(() {}); // Refresh notes
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Note saved successfully!")),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // 🔹 Edit note
  void editNote(Map<String, dynamic> note) {
    noteController.text = note['content'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Note"),
        content: TextField(controller: noteController),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final updatedNote = noteController.text.trim();
              if (updatedNote.isNotEmpty) {
                try {
                  await noteDb.updateNote(note['id'], updatedNote);
                  if (mounted) setState(() {});
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Note updated successfully!")),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // 🔹 Delete note
  void deleteNote(int noteId) async {
    try {
      await noteDb.deleteNote(noteId);
      if (mounted) setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Note deleted!")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // 🔹 Fetch notes for current user
  Future<List<Map<String, dynamic>>> fetchUserNotes() async {
    try {
      return await noteDb.getUserNotes();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching notes: $e")));
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Currency converter section
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  value: fromCurrency,
                  items: currencies
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => fromCurrency = val!),
                ),
                const Icon(Icons.arrow_forward),
                DropdownButton<String>(
                  value: toCurrency,
                  items: currencies
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => toCurrency = val!),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: convert, child: const Text('Convert')),
            const SizedBox(height: 20),
            Text(
              'Result: ${result.toStringAsFixed(2)} $toCurrency',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),

            // Notes section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Notes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(onPressed: addNewNote, icon: const Icon(Icons.add)),
              ],
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchUserNotes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final notes = snapshot.data ?? [];
                if (notes.isEmpty) {
                  return const Text("No notes yet.");
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(note['content']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => editNote(note),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deleteNote(note['id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
