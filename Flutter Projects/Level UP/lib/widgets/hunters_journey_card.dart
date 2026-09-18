import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/hunters_journey.dart';

class HuntersJourneyCard extends StatelessWidget {
  final HuntersJourney journey;
  final VoidCallback? onComplete;

  const HuntersJourneyCard({
    Key? key,
    required this.journey,
    this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryMagenta,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            journey.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryMagenta,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Description
          const SizedBox(height: 4),
          Text(
            journey.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),

          const SizedBox(height: 12),

          // Progress bar and days remaining
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: journey.completionPercentage,
                        backgroundColor: AppTheme.cardBorder,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryPurple,
                        ),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${journey.completedDays}/${journey.totalDays} Days Completed',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          '${(journey.completionPercentage * 100).toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // Days remaining badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryMagenta.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryMagenta,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      journey.daysRemaining.toString(),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.primaryMagenta,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Days Left',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryMagenta,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
