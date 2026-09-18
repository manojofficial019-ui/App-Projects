

class Player {
  String id;
  String name;
  int level;
  int exp;
  int expToNext;
  String rank; // E, D, C, B, A, S, SS
  int str;
  int dex;
  int intel;
  int vit;
  int maxHp;
  int hp;
  double critChance;
  double critDamage;
  List<String> skills;
  int currentStreak;
  int longestStreak;
  int completedQuests; // Number of days (quests) completed
  int totalChallengesCompleted;
  Map<String, List<bool>> streakDaysByMonth; // Map of "yyyy-mm" -> List<bool> (30 days)
  DateTime? lastQuestDate;

  Player({
    required this.id,
    required this.name,
    this.level = 1,
    this.exp = 0,
    this.expToNext = 75,
    this.rank = 'E',
    this.str = 10,
    this.dex = 10,
    this.intel = 10,
    this.vit = 10,
    this.maxHp = 100,
    this.hp = 100,
    this.critChance = 0.05,
    this.critDamage = 1.5,
    this.skills = const [],
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.completedQuests = 0,
    this.totalChallengesCompleted = 0,
    Map<String, List<bool>>? streakDaysByMonth,
    this.lastQuestDate,
  }) : streakDaysByMonth = streakDaysByMonth ?? {};

  /// Get or create streak data for a specific month
  List<bool> _getOrCreateMonthStreak(DateTime date) {
    final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    return streakDaysByMonth.putIfAbsent(
      monthKey,
      () => List<bool>.filled(30, false),
    );
  }

  /// Call this when a quest is completed. Handles streak logic.
  void completeQuest({DateTime? completionDate}) {
    final now = completionDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (lastQuestDate != null) {
      final last = DateTime(lastQuestDate!.year, lastQuestDate!.month, lastQuestDate!.day);
      final diff = today.difference(last).inDays;
      if (diff == 1) {
        // Consecutive day
        currentStreak++;
      } else if (diff > 1) {
        // Missed a day: reset to 0, then increment (0++)
        currentStreak = 0;
        currentStreak++;
      } // else diff == 0, same day, don't increment streak
    } else {
      currentStreak = 1;
    }
    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }
    lastQuestDate = today;
    completedQuests++;
    
    // Mark the day as completed in the appropriate month's streak array
    final monthStreak = _getOrCreateMonthStreak(today);
    final dayOfMonth = today.day - 1; // 0-indexed
    if (dayOfMonth >= 0 && dayOfMonth < 30) {
      monthStreak[dayOfMonth] = true;
    }
  }

  void gainExp(int amount) {
    exp += amount;
    while (exp >= expToNext) {
      exp -= expToNext;
      levelUp();
    }
  }

  void levelUp() {
    level++;
    // First 5 levels require 75 exp each
    if (level <= 5) {
      expToNext = 75;
    } else {
      // Level 6: 75 + 25 = 100
      // Level 7: 75 + 50 = 125
      // Level 8: 75 + 75 = 150, etc.
      expToNext = 75 + (25 * (level - 5));
    }
    str += 2;
    dex += 2;
    intel += 2;
    vit += 2;
    maxHp = 100;
    hp = maxHp;
    _updateRank();
  }

  void _updateRank() {
    if (level >= 100)
      rank = 'SS';
    else if (level >= 80)
      rank = 'S';
    else if (level >= 60)
      rank = 'A';
    else if (level >= 40)
      rank = 'B';
    else if (level >= 25)
      rank = 'C';
    else if (level >= 15)
      rank = 'D';
    else if (level >= 5)
      rank = 'E';
    else
      rank = 'E';
  }

  void takeDamage(int amount) {
    hp = (hp - amount).clamp(0, maxHp);
  }

  void heal(int amount) {
    hp = (hp + amount).clamp(0, maxHp);
  }

  /// Gain HP when a task is completed (max 15 HP per task)
  void gainHpForTaskComplete(int hpAmount) {
    hp = (hp + hpAmount).clamp(0, maxHp);
  }

  /// Lose HP when a task fails/expires (25 HP loss)
  void loseHpForTaskFailure(int hpAmount) {
    hp = (hp - hpAmount).clamp(0, maxHp);
    // Check if HP is depleted, trigger level down
    if (hp == 0) {
      decreaseLevel();
    }
  }

  /// Decrease level when HP reaches 0
  void decreaseLevel() {
    if (level > 1) {
      level--;
      hp = maxHp; // Reset HP to full when level decreases
      str = (str - 2).clamp(10, double.infinity).toInt();
      dex = (dex - 2).clamp(10, double.infinity).toInt();
      intel = (intel - 2).clamp(10, double.infinity).toInt();
      vit = (vit - 2).clamp(10, double.infinity).toInt();
      _updateRank();
    } else {
      // If already at level 1, just reset HP to 1 to avoid going to 0
      hp = 1;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'exp': exp,
      'expToNext': expToNext,
      'rank': rank,
      'str': str,
      'dex': dex,
      'intel': intel,
      'vit': vit,
      'maxHp': maxHp,
      'hp': hp,
      'critChance': critChance,
      'critDamage': critDamage,
      'skills': skills,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'completedQuests': completedQuests,
      'totalChallengesCompleted': totalChallengesCompleted,
      'streakDaysByMonth': streakDaysByMonth,
      'lastQuestDate': lastQuestDate?.toIso8601String(),
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    Map<String, List<bool>> convertStreakDays(dynamic raw) {
      if (raw == null) return {};
      if (raw is Map) {
        return raw.map((key, value) {
          return MapEntry(key.toString(), List<bool>.from(value as List));
        });
      }
      return {};
    }

    return Player(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Hunter',
      level: json['level'] ?? 1,
      exp: json['exp'] ?? 0,
      expToNext: json['expToNext'] ?? 75,
      rank: json['rank'] ?? 'E',
      str: json['str'] ?? 10,
      dex: json['dex'] ?? 10,
      intel: json['intel'] ?? 10,
      vit: json['vit'] ?? 10,
      maxHp: json['maxHp'] ?? 100,
      hp: json['hp'] ?? 100,
      critChance: (json['critChance'] ?? 0.05).toDouble(),
      critDamage: (json['critDamage'] ?? 1.5).toDouble(),
      skills: List<String>.from(json['skills'] ?? []),
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      completedQuests: json['completedQuests'] ?? 0,
      totalChallengesCompleted: json['totalChallengesCompleted'] ?? 0,
      streakDaysByMonth: convertStreakDays(json['streakDaysByMonth']),
      lastQuestDate: json['lastQuestDate'] != null
          ? DateTime.tryParse(json['lastQuestDate'])
          : null,
    );
  }
}
