import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/api_service.dart';

class RoutineDetailScreen extends StatefulWidget {
  final int routineId;
  final String title;

  const RoutineDetailScreen({
    super.key,
    required this.routineId,
    required this.title,
  });

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  List<dynamic> steps = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSteps();
  }

  Future<void> fetchSteps() async {
    final url = Uri.parse('${ApiService.baseUrl}/steps/${widget.routineId}');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${ApiService.token}',
      },
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      setState(() {
        steps = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar microetapas')),
      );
    }
  }

  Future<void> addStep(String title) async {
    final url = Uri.parse('${ApiService.baseUrl}/steps');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiService.token}',
      },
      body: jsonEncode({
        'routine_id': widget.routineId,
        'title': title,
      }),
    );

    if (response.statusCode == 201) {
      fetchSteps();
    }
  }

  Future<void> updateStep(int id, String title, bool done) async {
    final url = Uri.parse('${ApiService.baseUrl}/steps/$id');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiService.token}',
      },
      body: jsonEncode({
        'title': title,
        'done': done,
      }),
    );

    if (response.statusCode == 200) {
      fetchSteps();
    }
  }

  Future<void> deleteStep(int id) async {
    final url = Uri.parse('${ApiService.baseUrl}/steps/$id');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ${ApiService.token}',
      },
    );

    if (response.statusCode == 200) {
      fetchSteps();
    }
  }

  void showAddStepDialog() {
    final controller = TextEditingController();

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

  void showEditStepDialog(int index) {
    final controller = TextEditingController(
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
                  updateStep(
                    steps[index]['id'],
                    controller.text,
                    steps[index]['done'] == 1 || steps[index]['done'] == true,
                  );
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

  int get completedSteps {
    return steps.where((step) {
      return step['done'] == 1 || step['done'] == true;
    }).length;
  }

  bool isStepDone(dynamic step) {
    return step['done'] == 1 || step['done'] == true;
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
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : steps.isEmpty
                      ? const Center(
                          child: Text('Nenhuma microetapa cadastrada ainda.'),
                        )
                      : ListView.builder(
                          itemCount: steps.length,
                          itemBuilder: (context, index) {
                            final step = steps[index];
                            final done = isStepDone(step);

                            return Card(
                              child: ListTile(
                                leading: Checkbox(
                                  value: done,
                                  onChanged: (value) {
                                    updateStep(
                                      step['id'],
                                      step['title'],
                                      value!,
                                    );
                                  },
                                ),
                                title: Text(step['title']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showEditStepDialog(index);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        deleteStep(step['id']);
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