import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../main.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final _goalController = TextEditingController();

  void _showAddGoalDialog(AppState appState) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set a New Goal'),
          content: TextField(
            controller: _goalController,
            decoration: const InputDecoration(
              labelText: 'Goal Title',
              hintText: 'e.g., Read for 30 mins, Exercise',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_goalController.text.isNotEmpty) {
                  appState.addGoal(_goalController.text);
                  _goalController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Goal Setting')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(appState),
        child: const Icon(Icons.flag),
      ),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, child) {
          if (appState.goals.isEmpty) {
            return const Center(child: Text('No goals set yet. Aim high!'));
          }
          return ListView.builder(
            itemCount: appState.goals.length,
            itemBuilder: (context, index) {
              final goal = appState.goals[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              goal.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Text('${(goal.progress * 100).toInt()}%'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: goal.progress,
                        backgroundColor: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        minHeight: 10,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              final newProgress = (goal.progress + 0.1).clamp(
                                0.0,
                                1.0,
                              );
                              appState.updateGoalProgress(goal.id, newProgress);
                            },
                            child: const Text('Update Progress'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
