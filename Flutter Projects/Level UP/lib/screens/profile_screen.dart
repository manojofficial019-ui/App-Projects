import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/player.dart';

class ProfileScreen extends StatefulWidget {
  final Player player;

  const ProfileScreen({
    super.key,
    required this.player,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Avatar
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryPurple, AppTheme.primaryMagenta],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    widget.player.name,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  // Level and Rank
                  Text(
                    'Level ${widget.player.level} • Rank E',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Stats Grid
                  _buildStatsGrid(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
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
            'Player Statistics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryMagenta,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatItem('Experience', '${widget.player.exp}/${widget.player.expToNext}', AppTheme.accentGreen),
          const Divider(color: AppTheme.cardBorder),
          _buildStatItem('HP', '${widget.player.hp}/${widget.player.maxHp}', AppTheme.accentRed),
          const Divider(color: AppTheme.cardBorder),
          _buildStatItem('Current Streak', '${widget.player.currentStreak} days', AppTheme.primaryPurple),
          const Divider(color: AppTheme.cardBorder),
          _buildStatItem('Longest Streak', '${widget.player.longestStreak} days', AppTheme.accentYellow),
          const Divider(color: AppTheme.cardBorder),
          _buildStatItem('Completed Quests', '${widget.player.completedQuests}', AppTheme.accentCyan),
          const Divider(color: AppTheme.cardBorder),
          _buildStatItem('Challenges Completed', '${widget.player.totalChallengesCompleted}', AppTheme.accentOrange),
          // Attributes section removed
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
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
      ),
    );
  }
}

