import 'daily_timer.dart';

class DailyQuest {
  String id;
  String title;
  List<QuestTask> tasks;
  bool isCompleted;
  bool isLocked;
  DateTime date;
  DailyTimer? timer;
  DateTime? completedDate;

  DailyQuest({
    required this.id,
    required this.title,
    required this.tasks,
    this.isCompleted = false,
    this.isLocked = false,
    DateTime? date,
    this.timer,
    this.completedDate,
  }) : date = date ?? DateTime.now();

  int get completedTasksCount => tasks.where((t) => t.isCompleted).length;
  int get totalTasksCount => tasks.length;
  double get completionPercentage => totalTasksCount > 0 ? completedTasksCount / totalTasksCount : 0.0;

  /// Check if this quest was already completed today
  bool get completedToday {
    if (!isCompleted || completedDate == null) return false;
    final now = DateTime.now();
    final completed = completedDate!;
    return now.year == completed.year &&
           now.month == completed.month &&
           now.day == completed.day;
  }

  void completeTask(int index) {
    if (index >= 0 && index < tasks.length) {
      if (tasks[index].canCompleteToday()) {
        tasks[index].isCompleted = true;
        tasks[index].lastCompletedDate = DateTime.now();
        _checkCompletion();
      }
    }
  }

  void _checkCompletion() {
    isCompleted = tasks.every((task) => task.isCompleted);
    if (isCompleted && completedDate == null) {
      completedDate = DateTime.now();
    }
  }

  void reset() {
    for (var task in tasks) {
      task.isCompleted = false;
    }
    isCompleted = false;
    completedDate = null;
    if (timer != null) {
      timer = DailyTimer();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'tasks': tasks.map((t) => t.toJson()).toList(),
      'isCompleted': isCompleted,
      'isLocked': isLocked,
      'date': date.toIso8601String(),
      'timer': timer?.toJson(),
      'completedDate': completedDate?.toIso8601String(),
    };
  }

  factory DailyQuest.fromJson(Map<String, dynamic> json) {
    return DailyQuest(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Daily Tasks',
      tasks: (json['tasks'] as List<dynamic>?)
          ?.map((t) => QuestTask.fromJson(t))
          .toList() ?? [],
      isCompleted: json['isCompleted'] ?? false,
      isLocked: json['isLocked'] ?? false,
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      timer: json['timer'] != null ? DailyTimer.fromJson(json['timer']) : null,
      completedDate: json['completedDate'] != null ? DateTime.parse(json['completedDate']) : null,
    );
  }
}

class QuestTask {
  String id;
  String name;
  bool isCompleted;
  DateTime? lastCompletedDate;

  QuestTask({
    required this.id,
    required this.name,
    this.isCompleted = false,
    this.lastCompletedDate,
  });

  bool canCompleteToday() {
    if (!isCompleted) return true;
    if (lastCompletedDate == null) return true;
    
    final now = DateTime.now();
    final lastDate = lastCompletedDate!;
    
    // Check if the last completion was on a different day
    return now.year != lastDate.year || 
           now.month != lastDate.month || 
           now.day != lastDate.day;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
    };
  }

  factory QuestTask.fromJson(Map<String, dynamic> json) {
    return QuestTask(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      lastCompletedDate: json['lastCompletedDate'] != null 
          ? DateTime.parse(json['lastCompletedDate']) 
          : null,
    );
  }
}

