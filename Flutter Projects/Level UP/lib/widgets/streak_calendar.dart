import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../theme/app_theme.dart';

class StreakCalendar extends StatefulWidget {
  final int currentStreak;
  final int longestStreak;
  final int completedDays;
  final int remainingDays;
  final Map<String, List<bool>>? streakDaysByMonth;
  final int daysToShow;

  const StreakCalendar({
    Key? key,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.completedDays = 0,
    this.remainingDays = 30,
    this.streakDaysByMonth,
    this.daysToShow = 30,
  }) : super(key: key);

  @override
  State<StreakCalendar> createState() => _StreakCalendarState();
}

class _StreakCalendarState extends State<StreakCalendar> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = now;
    _selectedDay = now;
    _firstDay = DateTime(now.year - 1, now.month, now.day);
    _lastDay = DateTime(now.year + 1, now.month, now.day);
  }

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
          // Header with title and streak count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STREAK TRACKER',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.primaryMagenta,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget.currentStreak} Days',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.accentYellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Stats row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  value: widget.currentStreak.toString(),
                  label: 'Current',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  value: widget.completedDays.toString(),
                  label: 'Completed',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  value: widget.remainingDays.toString(),
                  label: 'Remaining',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Real Calendar
          TableCalendar(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                // Only mark days from the current month being viewed
                if (day.month != _focusedDay.month || day.year != _focusedDay.year) {
                  return null;
                }

                // Get the month key in "yyyy-mm" format
                final monthKey = '${day.year}-${day.month.toString().padLeft(2, '0')}';
                final monthData = widget.streakDaysByMonth?[monthKey];
                
                final isCompleted = monthData != null &&
                    day.day - 1 >= 0 &&
                    day.day - 1 < monthData.length &&
                    monthData[day.day - 1];

                if (isCompleted) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppTheme.accentGreen,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
            calendarStyle: CalendarStyle(
              // Cell styling
              cellMargin: const EdgeInsets.all(4),
              cellPadding: const EdgeInsets.all(4),
              defaultDecoration: BoxDecoration(
                color: AppTheme.darkBackground,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppTheme.cardBorder,
                  width: 1,
                ),
              ),
              selectedDecoration: BoxDecoration(
                color: AppTheme.primaryMagenta,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppTheme.primaryMagenta,
                  width: 2,
                ),
              ),
              todayDecoration: BoxDecoration(
                color: AppTheme.accentCyan.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppTheme.accentCyan,
                  width: 2,
                ),
              ),
              weekendDecoration: BoxDecoration(
                color: AppTheme.darkBackground.withOpacity(0.8),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppTheme.cardBorder,
                  width: 1,
                ),
              ),
              // Text styling
              defaultTextStyle: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              todayTextStyle: const TextStyle(
                color: AppTheme.accentCyan,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              weekendTextStyle: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
              outsideTextStyle: TextStyle(
                color: AppTheme.textSecondary.withOpacity(0.3),
                fontSize: 13,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryMagenta,
                fontWeight: FontWeight.bold,
              ) ?? const TextStyle(
                color: AppTheme.primaryMagenta,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: const Icon(
                Icons.chevron_left,
                color: AppTheme.primaryMagenta,
                size: 28,
              ),
              rightChevronIcon: const Icon(
                Icons.chevron_right,
                color: AppTheme.primaryMagenta,
                size: 28,
              ),
              headerPadding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.bold,
              ) ?? const TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.bold,
              ),
              weekendStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.bold,
              ) ?? const TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, {
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
