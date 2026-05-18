import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/api_service.dart';
import 'create_routine_screen.dart';
import 'routine_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> routines = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRoutines();
  }

  Future<void> fetchRoutines() async {
    final url = Uri.parse('${ApiService.baseUrl}/routines');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${ApiService.token}',
      },
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      setState(() {
        routines = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar rotinas')),
      );
    }
  }

  Future<void> createRoutine(String title, String description) async {
    final url = Uri.parse('${ApiService.baseUrl}/routines');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiService.token}',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      fetchRoutines();
    }
  }

  Future<void> updateRoutine(int id, String title, String description) async {
    final url = Uri.parse('${ApiService.baseUrl}/routines/$id');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiService.token}',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      fetchRoutines();
    }
  }

  Future<void> deleteRoutine(int id) async {
    final url = Uri.parse('${ApiService.baseUrl}/routines/$id');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ${ApiService.token}',
      },
    );

    if (response.statusCode == 200) {
      fetchRoutines();
    }
  }

  void openCreateRoutineScreen() async {
    final newRoutine = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateRoutineScreen(),
      ),
    );

    if (newRoutine != null) {
      createRoutine(
        newRoutine['title'],
        newRoutine['description'],
      );
    }
  }

  void showEditRoutineDialog(int index) {
    final titleController = TextEditingController(
      text: routines[index]['title'],
    );

    final descriptionController = TextEditingController(
      text: routines[index]['description'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar rotina'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Nome da rotina',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  updateRoutine(
                    routines[index]['id'],
                    titleController.text,
                    descriptionController.text,
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

  void confirmDeleteRoutine(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir rotina'),
          content: const Text('Tem certeza que deseja excluir esta rotina?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteRoutine(routines[index]['id']);
                Navigator.pop(context);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void openRoutineDetail(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoutineDetailScreen(
          title: routines[index]['title'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MindStep'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Olá 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Vamos organizar seu dia com calma.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Minhas rotinas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : routines.isEmpty
                      ? const Center(
                          child: Text('Nenhuma rotina cadastrada ainda.'),
                        )
                      : ListView.builder(
                          itemCount: routines.length,
                          itemBuilder: (context, index) {
                            return routineCard(index);
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreateRoutineScreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget routineCard(int index) {
    final title = routines[index]['title'];
    final description = routines[index]['description'] ?? '';

    return GestureDetector(
      onTap: () => openRoutineDetail(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.checklist, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => showEditRoutineDialog(index),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => confirmDeleteRoutine(index),
            ),
          ],
        ),
      ),
    );
  }
}