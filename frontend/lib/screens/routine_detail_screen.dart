import 'package:flutter/material.dart';

class RoutineDetailScreen extends StatefulWidget {
  final String title;

  const RoutineDetailScreen({
    super.key,
    required this.title,
  });

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  List<Map<String, dynamic>> steps = [
    {'title': 'Primeira microetapa', 'done': false},
  ];

  void addStep(String title) {
    setState(() {
      steps.add({
        'title': title,
        'done': false,
      });
    });
  }

  void showAddStepDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova microetapa'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Digite a microetapa',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  addStep(controller.text);
                }
                Navigator.pop(context);
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void toggleStep(int index, bool value) {
    setState(() {
      steps[index]['done'] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          return Card(
            child: CheckboxListTile(
              title: Text(steps[index]['title']),
              value: steps[index]['done'],
              onChanged: (value) {
                toggleStep(index, value!);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddStepDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}