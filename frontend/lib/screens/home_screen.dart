import 'package:flutter/material.dart';
import 'create_routine_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> routines = [
    {
      'title': 'Estudar Flutter',
      'description': 'Praticar telas e componentes',
    },
    {
      'title': 'Tomar água',
      'description': 'Lembrar durante o dia',
    },
  ];

  void addRoutine(Map<String, String> routine) {
    setState(() {
      routines.add(routine);
    });
  }

  void openCreateRoutineScreen() async {
    final newRoutine = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateRoutineScreen(),
      ),
    );

    if (newRoutine != null) {
      addRoutine({
        'title': newRoutine['title'],
        'description': newRoutine['description'],
      });
    }
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
              'Olá, Victor 👋',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              'Vamos organizar seu dia com calma.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),

            const SizedBox(height: 30),

            const Text(
              'Minhas rotinas',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: routines.length,

                itemBuilder: (context, index) {
                  return routineCard(
                    routines[index]['title']!,
                    routines[index]['description']!,
                  );
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

  Widget routineCard(String title, String description) {
    return Container(
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
        ],
      ),
    );
  }
}