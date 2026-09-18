class Achievement {
  String id;
  String title;
  String description;
  String icon;
  bool isUnlocked;
  DateTime? unlockedDate;
  int? requirement; // e.g., complete 10 tasks, reach level 5

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    this.icon = '⭐',
    this.isUnlocked = false,
    this.unlockedDate,
    this.requirement,
  });

  void unlock() {
    if (!isUnlocked) {
      isUnlocked = true;
      unlockedDate = DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'isUnlocked': isUnlocked,
      'unlockedDate': unlockedDate?.toIso8601String(),
      'requirement': requirement,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '⭐',
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedDate: json['unlockedDate'] != null ? DateTime.parse(json['unlockedDate']) : null,
      requirement: json['requirement'],
    );
  }
}

