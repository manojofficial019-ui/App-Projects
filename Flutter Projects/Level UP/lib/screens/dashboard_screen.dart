import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/player.dart';
import '../models/challenge.dart';
import '../models/hunters_journey.dart';
import '../widgets/stats_tracker_dialog.dart';
import '../widgets/hunters_journey_card.dart';
import '../widgets/streak_calendar.dart';


class DashboardScreen extends StatefulWidget {
  final Player player;
  final Challenge? activeChallenge;
  final HuntersJourney? huntersJourney;
  final VoidCallback? onViewStats;

  const DashboardScreen({
    super.key,
    required this.player,
    this.activeChallenge,
    this.huntersJourney,
    this.onViewStats,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => StatsTrackerDialog(player: widget.player),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hunter's Journey
                  if (widget.huntersJourney != null)
                    HuntersJourneyCard(journey: widget.huntersJourney!),
                  if (widget.huntersJourney != null) const SizedBox(height: 16),
                  
                  // Streak Tracker Calendar
                  StreakCalendar(
                    currentStreak: widget.player.currentStreak,
                    longestStreak: widget.player.longestStreak,
                    completedDays: widget.activeChallenge?.completedDays ?? 0,
                    remainingDays: widget.activeChallenge?.daysLeft ?? 0,
                    streakDaysByMonth: widget.player.streakDaysByMonth.isNotEmpty ? widget.player.streakDaysByMonth : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Overall Performance
                  _buildPerformanceCard(context),
                  const SizedBox(height: 16),
                  // Skills and Streak
                  Row(
                    children: [
                      Expanded(child: _buildSkillsCard(context)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildStreakCard(context)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Stats
                  _buildStatsCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(BuildContext context) {
    final completionRate = (widget.player.completedQuests / 30).clamp(0.0, 1.0);
    final grade = _getGrade(completionRate);
    
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
          Text(
            'OVERALL PERFORMANCE',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryMagenta,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(completionRate * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.accentRed, width: 3),
                    color: AppTheme.darkBackground,
                  ),
                  child: Center(
                    child: Text(
                      grade,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentRed,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: completionRate,
                backgroundColor: AppTheme.cardBorder,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completed: ${widget.player.completedQuests}/30 days',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Predicted: ${widget.player.completedQuests}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.accentYellow,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSkillsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        children: [
          Text(
            'Skills',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryMagenta,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hunter',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            'Level ${widget.player.level}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        children: [
          Text(
            'Streak',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryMagenta,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryPurple.withOpacity(0.2),
            ),
            child: Center(
              child: Text(
                '${widget.player.currentStreak}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Days',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

        ],
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
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
          Text(
            'Stats',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryMagenta,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow('Experience', 'EXP', widget.player.exp, widget.player.expToNext, 'Lv${widget.player.level}', AppTheme.accentGreen),
          const SizedBox(height: 12),
          _buildStatRow('HP', 'HP', widget.player.hp, widget.player.maxHp, 'Lv${widget.player.level}', AppTheme.accentRed),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Completed Quests', style: TextStyle(color: AppTheme.textPrimary)),
              Text(
                '${widget.player.completedQuests}',
                style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String prefix, int current, int max, String levelLabel, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textPrimary)),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(prefix, style: TextStyle(color: color)),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: current / max,
                  backgroundColor: AppTheme.cardBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(levelLabel, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            const SizedBox(width: 8),
            Text(
              '$current/$max',
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  String _getGrade(double percentage) {
    if (percentage >= 0.9) return 'A';
    if (percentage >= 0.8) return 'B';
    if (percentage >= 0.7) return 'C';
    if (percentage >= 0.6) return 'D';
    return 'E';
  }

  
}

