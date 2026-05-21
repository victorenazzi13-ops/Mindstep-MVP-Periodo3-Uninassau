import 'dart:convert';
import 'dart:math';

import 'package:confetti/confetti.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/api_service.dart';

import '../themes/app_theme.dart';

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
  late ConfettiController confettiController;

  final List<String> motivationalMessages = [
  'Excelente. Um passo de cada vez 🚀',
  'Você está avançando 💙',
  'Pequeno progresso ainda é progresso ✨',
  'Continue, você já começou 🔥',
  'Mais uma etapa vencida 🎯',
  'Respira. Você está indo bem 🌱',
  'Cada microetapa conta 💫',
  'Foco no próximo passo, não no todo 🎯',
  'Você já venceu a parte mais difícil: começar 🚀',
  'Disciplina vence motivação 🔥',
  'Mais perto do objetivo 💙',
  'Consistência gera resultado 📈',
  'Uma etapa de cada vez 🧠',
  'Seu eu do futuro agradece 🙌',
  'Você está construindo progresso real 🏗️',
];

  @override
void initState() {
  super.initState();

  confettiController = ConfettiController(
    duration: const Duration(seconds: 3),
  );

  fetchSteps();
}

@override
void dispose() {
  confettiController.dispose();
  super.dispose();
}

  Future<void> fetchSteps() async {
    final url = Uri.parse('${ApiService.baseUrl}/steps/${widget.routineId}');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${ApiService.token}'},
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
      body: jsonEncode({'routine_id': widget.routineId, 'title': title}),
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
      body: jsonEncode({'title': title, 'done': done}),
    );

    if (response.statusCode == 200) {
      fetchSteps();
    }
  }

  Future<void> deleteStep(int id) async {
    final url = Uri.parse('${ApiService.baseUrl}/steps/$id');

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer ${ApiService.token}'},
    );

    if (response.statusCode == 200) {
      fetchSteps();
    }
  }

  void startFocusMode() {
    final pendingSteps = steps.where((step) {
      return !isStepDone(step);
    }).toList();

    if (pendingSteps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todas as microetapas já foram concluídas 🎉'),
        ),
      );
      return;
    }

    showFocusDialog(pendingSteps, 0);
  }

  void showFocusDialog(List pendingSteps, int index) {
  final step = pendingSteps[index];

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text('Microetapa ${index + 1}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step['title'],
              style: const TextStyle(
                fontSize: 18,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              motivationalMessages[
                  Random().nextInt(motivationalMessages.length)],
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.mutedTextColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Fechar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              await updateStep(
                step['id'],
                step['title'],
                true,
              );

              if (!mounted) return;

              if (index + 1 < pendingSteps.length) {
                Future.delayed(const Duration(milliseconds: 700), () {
                  if (!mounted) return;
                  showFocusDialog(pendingSteps, index + 1);
                });
              } else {
                Future.delayed(const Duration(milliseconds: 700), () {
                  if (!mounted) return;

                  confettiController.play();

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('🎉 Parabéns!'),
                        content: const Text(
                          'Você concluiu toda a rotina!',
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Fechar'),
                          ),
                        ],
                      );
                    },
                  );
                });
              }
            },
            child: const Text('Concluir etapa'),
          ),
        ],
      );
    },
  );
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
              prefixIcon: Icon(Icons.add_task),
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
    final controller = TextEditingController(text: steps[index]['title']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar microetapa'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Editar microetapa',
              prefixIcon: Icon(Icons.edit),
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
                    isStepDone(steps[index]),
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

  double get progress {
    if (steps.isEmpty) return 0;
    return completedSteps / steps.length;
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    floatingActionButton: FloatingActionButton(
      onPressed: showAddStepDialog,
      child: const Icon(Icons.add),
    ),
    body: Stack(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topBar(),
                const SizedBox(height: 24),
                progressCard(),
                const SizedBox(height: 24),
                const Text(
                  'Microetapas',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : steps.isEmpty
                          ? emptyState()
                          : ListView.builder(
                              itemCount: steps.length,
                              itemBuilder: (context, index) {
                                final step = steps[index];
                                final done = isStepDone(step);

                                return stepCard(step, done, index);
                              },
                            ),
                ),
              ],
            ),
          ),
        ),

        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            emissionFrequency: 0.05,
            numberOfParticles: 25,
            gravity: 0.2,
          ),
        ),
      ],
    ),
  );
}

  Widget topBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.surfaceColor,
            foregroundColor: AppTheme.textColor,
            padding: const EdgeInsets.all(14),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget progressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progresso da rotina',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$completedSteps de ${steps.length} concluídas',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(value: progress, minHeight: 10),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: startFocusMode,
              icon: const Icon(Icons.psychology_alt),
              label: const Text('Iniciar modo foco'),
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
            Icons.checklist,
            size: 70,
            color: Colors.white.withValues(alpha: 0.35),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nenhuma microetapa ainda',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adicione pequenos passos para começar.',
            style: TextStyle(color: AppTheme.mutedTextColor),
          ),
        ],
      ),
    );
  }

  Widget stepCard(dynamic step, bool done, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: done,
            onChanged: (value) {
              updateStep(step['id'], step['title'], value!);
            },
          ),
          Expanded(
            child: Text(
              step['title'],
              style: TextStyle(
                fontSize: 16,
                color: done ? AppTheme.mutedTextColor : AppTheme.textColor,
                decoration: done ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showEditStepDialog(index);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppTheme.dangerColor),
            onPressed: () {
              deleteStep(step['id']);
            },
          ),
        ],
      ),
    );
  }
}
