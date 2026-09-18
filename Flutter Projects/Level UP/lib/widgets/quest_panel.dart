import 'package:flutter/material.dart';
import '../models/quest.dart';

class QuestPanel extends StatelessWidget {
  final DailyQuest quest;
  final VoidCallback? onTaskComplete;
  final VoidCallback? onQuestComplete;

  // Theme colors
  static const Color brandDark = Color(0xFF0D47A1);
  static const Color brandBlue = Color(0xFF1565C0);
  static const Color brandGreen = Color(0xFF2E7D32);
  static const Color brandCyan = Color(0xFF00BCD4);
  static const Color brandAccent = Color(0xFF00ACC1);
  static const Color brandGold = Color(0xFFFFD700);
  static const Color brandPurple = Color(0xFF8B00FF);

  const QuestPanel({
    super.key,
    required this.quest,
    this.onTaskComplete,
    this.onQuestComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: brandDark.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: brandGreen.withOpacity(0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: brandGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildPanelHeader(context),
          const SizedBox(height: 28),
          // Quest Title
          _buildQuestTitle(context),
          const SizedBox(height: 28),
          // Goals Section
          _buildGoalSection(context),
          const SizedBox(height: 28),
          // Warning Section
          _buildWarningSection(context),
          const SizedBox(height: 28),
          // Completion Status
          _buildCompletionStatus(context),
        ],
      ),
    );
  }

  Widget _buildPanelHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 28,
          decoration: BoxDecoration(
            color: brandGreen,
            borderRadius: BorderRadius.circular(1.5),
            boxShadow: [
              BoxShadow(
                color: brandGreen.withOpacity(0.6),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'QUEST INFO',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: brandGreen,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                fontSize: 18,
              ),
        ),
      ],
    );
  }

  Widget _buildQuestTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '[Daily Quest: ${quest.title}]',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: brandGreen.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
        ),
      ],
    );
  }

  Widget _buildGoalSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          'GOAL',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: brandGreen,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 16),
        // Goals List
        ...quest.tasks.asMap().entries.map((entry) {
          final index = entry.key;
          final task = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildGoalItem(context, task, index),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildGoalItem(BuildContext context, QuestTask task, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: brandGreen.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Checkbox
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: task.isCompleted ? brandGreen : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: brandGreen,
                width: 1.5,
              ),
            ),
            child: task.isCompleted
                ? const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: task.isCompleted
                        ? brandGreen.withOpacity(0.6)
                        : brandDark,
                    fontWeight: FontWeight.w500,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
            ),
          ),
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: brandGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: brandGreen.withOpacity(0.4),
                width: 0.5,
              ),
            ),
            child: Text(
              '[100/100]',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: brandGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: brandPurple.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: brandPurple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WARNING:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: brandPurple,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
              ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Failure to complete\nthe daily quest will result in\nan appropriate ',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: brandDark.withOpacity(0.7),
                        fontSize: 12,
                        height: 1.5,
                      ),
                ),
                TextSpan(
                  text: 'penalty',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: brandPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionStatus(BuildContext context) {
    return Center(
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: brandBlue.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: brandGreen.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Icon(
          Icons.check_circle,
          color: quest.isCompleted ? brandGreen : brandGreen.withOpacity(0.3),
          size: 32,
        ),
      ),
    );
  }
}
