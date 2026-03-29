import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../main.dart';

class TriggerScreen extends StatefulWidget {
  const TriggerScreen({super.key});

  @override
  State<TriggerScreen> createState() => _TriggerScreenState();
}

class _TriggerScreenState extends State<TriggerScreen> {
  final _triggerController = TextEditingController();

  void _showAddTriggerDialog(AppState appState) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a Trigger to Avoid'),
          content: TextField(
            controller: _triggerController,
            decoration: const InputDecoration(
              labelText: 'Trigger Name',
              hintText: 'e.g., Caffeine, Late night scrolling',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_triggerController.text.isNotEmpty) {
                  appState.addTrigger(_triggerController.text);
                  _triggerController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
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
      appBar: AppBar(title: const Text('Trigger Management')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTriggerDialog(appState),
        child: const Icon(Icons.warning),
      ),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, child) {
          if (appState.triggers.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield_outlined, size: 100, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No triggers recorded. Stay vigilant!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: appState.triggers.length,
            itemBuilder: (context, index) {
              final trigger = appState.triggers[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.dangerous, color: Colors.redAccent),
                  title: Text(
                    trigger.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => appState.removeTrigger(trigger.id),
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
