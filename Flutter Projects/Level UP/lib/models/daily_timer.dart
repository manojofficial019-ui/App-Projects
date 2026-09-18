import 'package:flutter/foundation.dart';

class DailyTimer extends ChangeNotifier {
  DateTime _lastReset;
  Duration _timeRemaining;
  
  DailyTimer({DateTime? lastReset}) 
    : _lastReset = lastReset ?? DateTime.now(),
      _timeRemaining = _calculateTimeRemaining(lastReset ?? DateTime.now());

  static Duration _calculateTimeRemaining(DateTime lastReset) {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final difference = midnight.difference(now);
    return difference.isNegative ? const Duration(hours: 24) : difference;
  }

  Duration get timeRemaining {
    _timeRemaining = _calculateTimeRemaining(_lastReset);
    return _timeRemaining;
  }

  String get formattedTime {
    final duration = timeRemaining;
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String get formattedTimeRemaining {
    final duration = timeRemaining;
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    }
    return '${duration.inMinutes}m';
  }

  double get progress {
    final total = const Duration(hours: 24).inSeconds;
    final remaining = timeRemaining.inSeconds;
    return 1.0 - (remaining / total);
  }

  bool checkAndReset() {
    final now = DateTime.now();
    if (now.day != _lastReset.day || now.month != _lastReset.month || now.year != _lastReset.year) {
      _lastReset = now;
      _timeRemaining = _calculateTimeRemaining(now);
      notifyListeners();
      return true;
    }
    return false;
  }

  DateTime get lastReset => _lastReset;

  Map<String, dynamic> toJson() {
    return {
      'lastReset': _lastReset.toIso8601String(),
    };
  }

  factory DailyTimer.fromJson(Map<String, dynamic> json) {
    return DailyTimer(
      lastReset: DateTime.parse(json['lastReset']),
    );
  }
}

