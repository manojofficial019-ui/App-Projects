class Challenge {
  String id;
  String title;
  int durationDays;
  List<String> taskNames;
  DateTime startDate;
  DateTime? endDate;
  bool isCompleted;
  bool isArchived; // Marks challenges as untouchable in history
  Map<DateTime, bool> dailyCompletion; // Track which days were completed
  int currentDay;

  Challenge({
    required this.id,
    required this.title,
    required this.durationDays,
    required this.taskNames,
    DateTime? startDate,
    this.endDate,
    this.isCompleted = false,
    this.isArchived = false,
    Map<DateTime, bool>? dailyCompletion,
    this.currentDay = 1,
  })  : startDate = startDate ?? DateTime.now(),
        dailyCompletion = dailyCompletion ?? {};

  int get completedDays => dailyCompletion.values.where((v) => v).length;
  double get completionPercentage => durationDays > 0 ? completedDays / durationDays : 0.0;
  
  int get _calculatedCurrentDay {
    final now = DateTime.now();
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final current = DateTime(now.year, now.month, now.day);
    final calculated = current.difference(start).inDays + 1;
    return calculated > durationDays ? durationDays : calculated;
  }
  
  int get daysLeft {
    final remaining = durationDays - _calculatedCurrentDay + 1;
    return remaining < 0 ? 0 : remaining;
  }

  void markDayCompleted(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    dailyCompletion[dateOnly] = true;
    _updateCurrentDay();
  }

  void _updateCurrentDay() {
    final now = DateTime.now();
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final current = DateTime(now.year, now.month, now.day);
    currentDay = current.difference(start).inDays + 1;
    if (currentDay > durationDays) {
      currentDay = durationDays;
    }
    _checkCompletion();
  }

  void _checkCompletion() {
    isCompleted = completedDays >= durationDays;
    if (isCompleted && endDate == null) {
      endDate = DateTime.now();
      isArchived = true; // Archive the challenge when it's completed
    }
  }

  bool isDayCompleted(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dailyCompletion[dateOnly] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'durationDays': durationDays,
      'taskNames': taskNames,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'isArchived': isArchived,
      'dailyCompletion': dailyCompletion.map((k, v) => MapEntry(k.toIso8601String(), v)),
      'currentDay': currentDay,
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      durationDays: json['durationDays'] ?? 30,
      taskNames: List<String>.from(json['taskNames'] ?? []),
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCompleted: json['isCompleted'] ?? false,
      isArchived: json['isArchived'] ?? false,
      dailyCompletion: (json['dailyCompletion'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(DateTime.parse(k), v as bool)) ?? {},
      currentDay: json['currentDay'] ?? 1,
    );
  }
}

