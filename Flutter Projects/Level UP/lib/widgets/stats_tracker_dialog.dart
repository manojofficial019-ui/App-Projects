import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/player.dart';

class StatsTrackerDialog extends StatelessWidget {
  final Player player;

  const StatsTrackerDialog({
    super.key,
    required this.player,
  });

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
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stats Tracker',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildStatRow('Level', player.level.toString(), AppTheme.accentCyan),
            const SizedBox(height: 16),
            _buildStatRow('Experience', '${player.exp}/${player.expToNext}', AppTheme.accentGreen),
            const SizedBox(height: 16),
            _buildStatRow('HP', '${player.hp}/${player.maxHp}', AppTheme.accentRed),
            const SizedBox(height: 16),
            _buildStatRow('Completed Quests', player.completedQuests.toString(), AppTheme.accentCyan),
            const SizedBox(height: 16),
            _buildStatRow('Current Streak', '${player.currentStreak} days', AppTheme.primaryPurple),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

