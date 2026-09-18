import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final TextEditingController _durationController = TextEditingController(text: '30');
  final List<String> _selectedTasks = [];

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  void _showTaskSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => _TaskSelectionDialog(
        selectedTasks: _selectedTasks,
        onTasksSelected: (tasks) {
          setState(() {
            _selectedTasks.clear();
            _selectedTasks.addAll(tasks);
          });
        },
      ),
    );
  }

  void _createChallenge() {
    if (_selectedTasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one task'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
      return;
    }

    final duration = int.tryParse(_durationController.text);
    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid duration'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
      return;
    }

    // Challenge creation logic would go here
    Navigator.of(context).pop({
      'duration': duration,
      'tasks': _selectedTasks,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Start New Challenge'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Challenge Duration
            Text(
              'Challenge Duration (days):',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppTheme.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.primaryPurple),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.primaryPurple),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.primaryPurple, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Add Task Names
            Text(
              'Add Task Names:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _showTaskSelectionDialog,
              icon: const Icon(Icons.edit, size: 20),
              label: const Text('Tasks'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentRed,
                foregroundColor: AppTheme.darkBackground,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            // Selected Tasks
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Tasks (${_selectedTasks.length}):',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryMagenta,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_selectedTasks.isEmpty)
                    Text(
                      'No tasks added yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    )
                  else
                    ..._selectedTasks.map((task) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Text('- ', style: TextStyle(color: AppTheme.accentCyan)),
                          Expanded(
                            child: Text(
                              task,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.accentCyan,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _createChallenge,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryMagenta,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Start'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskSelectionDialog extends StatefulWidget {
  final List<String> selectedTasks;
  final Function(List<String>) onTasksSelected;

  const _TaskSelectionDialog({
    required this.selectedTasks,
    required this.onTasksSelected,
  });

  @override
  State<_TaskSelectionDialog> createState() => _TaskSelectionDialogState();
}

class _TaskSelectionDialogState extends State<_TaskSelectionDialog> {
  final TextEditingController _taskController = TextEditingController();
  final List<String> _tasks = [];

  @override
  void initState() {
    super.initState();
    _tasks.addAll(widget.selectedTasks);
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    final task = _taskController.text.trim();
    if (task.isNotEmpty && !_tasks.contains(task)) {
      setState(() {
        _tasks.add(task);
        _taskController.clear();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _confirm() {
    widget.onTasksSelected(_tasks);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.cardBorder),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Tasks',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'Enter task name',
                      filled: true,
                      fillColor: AppTheme.darkBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add, color: AppTheme.accentCyan),
                  onPressed: _addTask,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_tasks[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: AppTheme.accentRed),
                      onPressed: () => _removeTask(index),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _confirm,
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

