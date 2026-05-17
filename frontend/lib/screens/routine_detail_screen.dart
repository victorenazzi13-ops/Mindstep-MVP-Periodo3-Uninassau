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

  void removeStep(int index) {
    setState(() {
      steps.removeAt(index);
    });
  }

  void toggleStep(int index, bool value) {
    setState(() {
      steps[index]['done'] = value;
    });
  }

  void editStep(int index) {
    TextEditingController controller = TextEditingController(
      text: steps[index]['title'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar microetapa'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Editar microetapa',
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
                  setState(() {
                    steps[index]['title'] = controller.text;
                  });
                }

                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
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

  int get completedSteps {
    return steps.where((step) => step['done'] == true).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$completedSteps de ${steps.length} concluídas',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: steps[index]['done'],
                        onChanged: (value) {
                          toggleStep(index, value!);
                        },
                      ),

                      title: Text(steps[index]['title']),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              editStep(index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              removeStep(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddStepDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}