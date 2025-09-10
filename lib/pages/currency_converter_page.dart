import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/note_db.dart';

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

  // Note save function
  void addNewNote() {
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
              final newNote = noteController.text;
              if (newNote.isNotEmpty) {
                try {
                  await noteDb.createNote(newNote); // Save to Supabase
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Note saved successfully!")),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                }
              }
              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // Currency convert function
  void convert() {
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) return;

    final usdAmount = amount / rates[fromCurrency]!;
    final converted = usdAmount * rates[toCurrency]!;

    setState(() {
      result = converted;
    });
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote, // Save note to Supabase
        child: const Icon(Icons.add),
      ),
    );
  }
}
