import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/api_service.dart';
import '../themes/app_theme.dart';
import 'create_routine_screen.dart';
import 'routine_detail_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> routines = [];
  bool isLoading = true;

  void logout() {
  ApiService.token = null;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
}

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
                  prefixIcon: Icon(Icons.edit_note),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.notes),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.dangerColor,
              ),
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
          routineId: routines[index]['id'],
          title: routines[index]['title'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchRoutines,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(),
                const SizedBox(height: 28),
                summaryCard(),
                const SizedBox(height: 28),
                const Text(
                  'Minhas rotinas',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : routines.isEmpty
                          ? emptyState()
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreateRoutineScreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget header() {
  return Row(
    children: [
      Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppTheme.primaryColor,
              AppTheme.secondaryColor,
            ],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.psychology_alt,
          color: Colors.white,
          size: 30,
        ),
      ),

      const SizedBox(width: 14),

      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá 👋',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Organize sua mente, um passo de cada vez.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.mutedTextColor,
              ),
            ),
          ],
        ),
      ),

      IconButton(
        onPressed: logout,
        icon: const Icon(Icons.logout),
        style: IconButton.styleFrom(
          backgroundColor: AppTheme.surfaceColor,
          foregroundColor: AppTheme.textColor,
          padding: const EdgeInsets.all(14),
        ),
      ),
    ],
  );
}

  Widget summaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.secondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seu painel de rotinas',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            routines.isEmpty
                ? 'Crie sua primeira rotina e divida em microetapas.'
                : 'Você tem ${routines.length} rotina(s) cadastrada(s).',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.checklist_rtl,
            size: 72,
            color: Colors.white.withValues(alpha: 0.35),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nenhuma rotina ainda',
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Toque em “Nova rotina” para começar.',
            style: TextStyle(
              color: AppTheme.mutedTextColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget routineCard(int index) {
    final title = routines[index]['title'];
    final description = routines[index]['description'] ?? '';

    return GestureDetector(
      onTap: () => openRoutineDetail(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.route,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description.isEmpty ? 'Sem descrição' : description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.mutedTextColor,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              color: AppTheme.surfaceColor,
              icon: const Icon(
                Icons.more_vert,
                color: AppTheme.mutedTextColor,
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  showEditRoutineDialog(index);
                }

                if (value == 'delete') {
                  confirmDeleteRoutine(index);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Text('Editar'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Excluir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}