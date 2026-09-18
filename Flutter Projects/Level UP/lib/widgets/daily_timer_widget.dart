import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/daily_timer.dart';

class DailyTimerWidget extends StatefulWidget {
  final DailyTimer timer;

  const DailyTimerWidget({
    super.key,
    required this.timer,
  });

  @override
  State<DailyTimerWidget> createState() => _DailyTimerWidgetState();
}

class _DailyTimerWidgetState extends State<DailyTimerWidget> {
  @override
  void initState() {
    super.initState();
    widget.timer.addListener(_updateTimer);
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {});
        _startTimer();
      }
    });
  }

  void _updateTimer() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.timer.removeListener(_updateTimer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeRemaining = widget.timer.timeRemaining;
    final hours = timeRemaining.inHours;
    final minutes = timeRemaining.inMinutes % 60;
    final seconds = timeRemaining.inSeconds % 60;
    final timeString = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentYellow.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentYellow.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DAILY TIMER (12am - 11:59pm)',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.accentYellow,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            timeString,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Time Remaining',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: widget.timer.progress,
              backgroundColor: AppTheme.cardBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentYellow),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reset: 00:00',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                widget.timer.formattedTimeRemaining,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.accentYellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Quest will reset automatically at midnight. All task progress resets.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

