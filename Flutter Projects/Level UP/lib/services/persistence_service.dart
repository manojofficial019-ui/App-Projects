import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';
import '../models/quest.dart';
import '../models/challenge.dart';
import '../models/achievement.dart';

class PersistenceService {
  static const String _playerKey = 'player';
  static const String _questKey = 'daily_quest';
  static const String _challengesKey = 'challenges';
  static const String _achievementsKey = 'achievements';
  static const String _activeChallengeKey = 'active_challenge';

  // Player
  Future<void> savePlayer(Player player) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_playerKey, jsonEncode(player.toJson()));
  }

  Future<Player?> loadPlayer() async {
    final prefs = await SharedPreferences.getInstance();
    final playerData = prefs.getString(_playerKey);
    if (playerData != null) {
      return Player.fromJson(jsonDecode(playerData));
    }
    return null;
  }

  // Daily Quest
  Future<void> saveDailyQuest(DailyQuest quest) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_questKey, jsonEncode(quest.toJson()));
  }

  Future<DailyQuest?> loadDailyQuest() async {
    final prefs = await SharedPreferences.getInstance();
    final questData = prefs.getString(_questKey);
    if (questData != null) {
      return DailyQuest.fromJson(jsonDecode(questData));
    }
    return null;
  }

  // Challenges
  Future<void> saveChallenges(List<Challenge> challenges) async {
    final prefs = await SharedPreferences.getInstance();
    final challengesData = challenges.map((c) => c.toJson()).toList();
    await prefs.setString(_challengesKey, jsonEncode(challengesData));
  }

  Future<List<Challenge>> loadChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    final challengesData = prefs.getString(_challengesKey);
    if (challengesData != null) {
      final List<dynamic> decoded = jsonDecode(challengesData);
      return decoded.map((c) => Challenge.fromJson(c)).toList();
    }
    return [];
  }

  // Active Challenge
  Future<void> saveActiveChallenge(String? challengeId) async {
    final prefs = await SharedPreferences.getInstance();
    if (challengeId != null) {
      await prefs.setString(_activeChallengeKey, challengeId);
    } else {
      await prefs.remove(_activeChallengeKey);
    }
  }

  Future<String?> loadActiveChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeChallengeKey);
  }

  // Achievements
  Future<void> saveAchievements(List<Achievement> achievements) async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsData = achievements.map((a) => a.toJson()).toList();
    await prefs.setString(_achievementsKey, jsonEncode(achievementsData));
  }

  Future<List<Achievement>> loadAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsData = prefs.getString(_achievementsKey);
    if (achievementsData != null) {
      final List<dynamic> decoded = jsonDecode(achievementsData);
      return decoded.map((a) => Achievement.fromJson(a)).toList();
    }
    return [];
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

