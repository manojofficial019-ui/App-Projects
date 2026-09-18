import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/player.dart';

class PlayerStatusCard extends StatelessWidget {
  final Player player;
  final Animation<double>? levelUpAnimation;

  const PlayerStatusCard({
    super.key,
    required this.player,
    this.levelUpAnimation,
  });

  @override
  Widget build(BuildContext context) {
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
            'PLAYER STATUS',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryMagenta,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (levelUpAnimation != null)
                ScaleTransition(
                  scale: levelUpAnimation!,
                  child: Text(
                    'Level ${player.level}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                Text(
                  'Level ${player.level}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Text(
                '${player.hp}/${player.maxHp} HP',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.accentRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: player.hp / player.maxHp,
              backgroundColor: AppTheme.cardBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentRed),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EXP',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.accentGreen,
                ),
              ),
              Text(
                '${player.exp}/${player.expToNext}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: player.exp / player.expToNext,
              backgroundColor: AppTheme.cardBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentGreen),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

