class HuntersJourney {
  String title;
  String description;
  int totalDays;
  int completedDays;
  DateTime startDate;

  HuntersJourney({
    this.title = "HUNTER'S JOURNEY",
    this.description = "Become stronger through consistent daily training",
    this.totalDays = 30,
    this.completedDays = 0,
    DateTime? startDate,
  }) : startDate = startDate ?? DateTime.now();

  int get _calculatedCurrentDay {
    final now = DateTime.now();
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final current = DateTime(now.year, now.month, now.day);
    final calculated = current.difference(start).inDays + 1;
    return calculated > totalDays ? totalDays : calculated;
  }

  int get daysRemaining {
    final remaining = totalDays - _calculatedCurrentDay + 1;
    return remaining < 0 ? 0 : remaining;
  }

  double get completionPercentage => 
    totalDays > 0 ? completedDays / totalDays : 0.0;

  void completeDay() {
    if (completedDays < totalDays) {
      completedDays++;
    }
  }

  void resetJourney() {
    completedDays = 0;
    startDate = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'totalDays': totalDays,
      'completedDays': completedDays,
      'startDate': startDate.toIso8601String(),
    };
  }

  factory HuntersJourney.fromJson(Map<String, dynamic> json) {
    return HuntersJourney(
      title: json['title'] ?? "HUNTER'S JOURNEY",
      description: json['description'] ?? "Become stronger through consistent daily training",
      totalDays: json['totalDays'] ?? 30,
      completedDays: json['completedDays'] ?? 0,
      startDate: json['startDate'] != null 
        ? DateTime.parse(json['startDate'])
        : DateTime.now(),
    );
  }
}
