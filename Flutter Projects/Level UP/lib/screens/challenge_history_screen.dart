import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/challenge.dart';

class ChallengeHistoryScreen extends StatelessWidget {
  final List<Challenge> challenges;

  const ChallengeHistoryScreen({
    super.key,
    required this.challenges,
  });

  @override
  Widget build(BuildContext context) {
    // Filter archived/completed challenges
    final completedChallenges = challenges.where((c) => c.isCompleted || c.isArchived).toList();
    completedChallenges.sort((a, b) => (b.endDate ?? b.startDate).compareTo(a.endDate ?? a.startDate));
    
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Challenge History'),
      ),
      body: completedChallenges.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No challenges completed yet',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: completedChallenges.length,
              itemBuilder: (context, index) {
                final challenge = completedChallenges[index];
                return _buildChallengeCard(context, challenge);
              },
            ),
    );
  }

  Widget _buildChallengeCard(BuildContext context, Challenge challenge) {
    final isArchived = challenge.isArchived || challenge.isCompleted;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isArchived ? AppTheme.accentGreen.withOpacity(0.5) : AppTheme.cardBorder,
          width: isArchived ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Title
          Text(
            challenge.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryMagenta,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          
          // Challenge Info
          Text(
            'Duration: ${challenge.durationDays} days',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Completed: ${challenge.completedDays}/${challenge.durationDays} days',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.accentGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: challenge.completionPercentage,
              backgroundColor: AppTheme.cardBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentGreen),
              minHeight: 8,
            ),
          ),
          
          // Starting Date Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.darkBackground,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppTheme.primaryMagenta,
                ),
                const SizedBox(width: 8),
                Text(
                  'Started on: ${_formatDate(challenge.startDate)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // Completion Info
          if (challenge.endDate != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.darkBackground,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Completed on: ${_formatDate(challenge.endDate!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '✓ Challenge saved to history',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.accentGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Tasks List
          if (challenge.taskNames.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Tasks (${challenge.taskNames.length}):',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.darkBackground,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: challenge.taskNames.map((task) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(color: AppTheme.primaryMagenta),
                      ),
                      Expanded(
                        child: Text(
                          task,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ],

        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

