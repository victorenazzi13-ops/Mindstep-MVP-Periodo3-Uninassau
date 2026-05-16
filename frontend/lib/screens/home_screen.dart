import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

            Container(
              padding: const EdgeInsets.all(20),

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Tarefas concluídas',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        '2 de 5',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  CircularProgressIndicator(
                    value: 0.4,
                    strokeWidth: 8,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Tarefas de hoje',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            taskCard(
              'Estudar Flutter',
              'Prioridade alta',
            ),

            const SizedBox(height: 15),

            taskCard(
              'Tomar água',
              'Pequena pausa',
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},

        child: const Icon(Icons.add),
      ),
    );
  }

  Widget taskCard(String title, String subtitle) {
    return Container(
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
          Checkbox(
            value: false,
            onChanged: (value) {},
          ),

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

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  style: TextStyle(
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