import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/quest.dart';
import '../models/daily_timer.dart';

class QuestCard extends StatelessWidget {
  final DailyQuest quest;
  final VoidCallback? onTaskComplete;
  final VoidCallback? onQuestComplete;

  const QuestCard({
    super.key,
    required this.quest,
    this.onTaskComplete,
    this.onQuestComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (quest.isLocked) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.accentYellow.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.accentYellow.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.lock, color: AppTheme.accentYellow),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Quest page locked - Complete your daily challenge',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.accentYellow,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppTheme.accentTeal, size: 20),
              const SizedBox(width: 8),
              Text(
                'QUEST INFO',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.accentTeal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '[Daily Quest: ${quest.title}]',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          if (quest.tasks.isNotEmpty) ...[
            const Text(
              'GOAL',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...quest.tasks.map((task) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: quest.completedToday
                        ? null
                        : (value) {
                            if (value == true && !task.isCompleted) {
                              final index = quest.tasks.indexOf(task);
                              quest.completeTask(index);
                              onTaskComplete?.call();
                              if (quest.isCompleted) {
                                onQuestComplete?.call();
                              }
                            }
                          },
                    activeColor: AppTheme.accentGreen,
                  ),
                  Expanded(
                    child: Text(
                      task.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        decoration: task.isCompleted 
                          ? TextDecoration.lineThrough 
                          : TextDecoration.none,
                        color: quest.completedToday 
                          ? AppTheme.textPrimary.withOpacity(0.5)
                          : null,
                      ),
                    ),
                  ),
                  Text(
                    '[${quest.completedTasksCount}/${quest.totalTasksCount}]',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            )),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.accentRed.withOpacity(0.5)),
            ),
            child: Text(
              'WARNING: Failure to complete the daily quest will result in an appropriate penalty.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.accentRed,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: quest.completedToday
                    ? null
                    : () {
                        for (var task in quest.tasks) {
                          task.isCompleted = true;
                        }
                        quest.isCompleted = true;
                        quest.completedDate = DateTime.now();
                        if (quest.timer != null) {
                          quest.timer = DailyTimer(lastReset: DateTime.now());
                        }
                        onQuestComplete?.call();
                      },
                icon: const Icon(Icons.check, size: 20),
                label: const Text('Complete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGreen,
                  disabledBackgroundColor: AppTheme.cardBorder,
                ),
              ),
              ElevatedButton.icon(
                onPressed: quest.completedToday
                    ? null
                    : () {
                        quest.reset();
                        onTaskComplete?.call();
                      },
                icon: const Icon(Icons.close, size: 20),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentRed,
                  disabledBackgroundColor: AppTheme.cardBorder,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              quest.completedToday
                  ? 'Status: COMPLETED TODAY'
                  : 'Status: ${quest.isCompleted ? 'COMPLETED' : 'ACTIVE'}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: quest.completedToday
                    ? AppTheme.accentGreen
                    : quest.isCompleted
                        ? AppTheme.accentGreen
                        : AppTheme.accentYellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

