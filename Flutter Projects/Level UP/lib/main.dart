import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'models/player.dart';
import 'models/quest.dart';
import 'models/challenge.dart';
import 'models/achievement.dart';
import 'models/daily_timer.dart';
import 'models/hunters_journey.dart';
import 'services/persistence_service.dart';
import 'theme/app_theme.dart';
import 'widgets/bottom_navigation.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/quest_screen.dart';
import 'screens/challenge_screen.dart';
import 'screens/challenge_history_screen.dart';
import 'screens/achievements_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const LevelUpApp());
}

class LevelUpApp extends StatelessWidget {
  const LevelUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Level Up',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late Player _player;
  DailyQuest? _dailyQuest;
  Challenge? _activeChallenge;
  List<Challenge> _challenges = [];
  List<Achievement> _achievements = [];
  late HuntersJourney _huntersJourney;
  final PersistenceService _persistenceService = PersistenceService();
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    // Load player
    _player = await _persistenceService.loadPlayer() ?? Player(
      id: 'player_1',
      name: 'Hunter',
    );

    // Load daily quest
    _dailyQuest = await _persistenceService.loadDailyQuest();
    if (_dailyQuest == null) {
      _dailyQuest = DailyQuest(
        id: 'quest_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Daily Tasks',
        tasks: [],
        timer: DailyTimer(),
      );
    }

    // Check if quest needs reset
    if (_dailyQuest!.timer != null) {
      final shouldReset = _dailyQuest!.timer!.checkAndReset();
      if (shouldReset) {
        // Apply HP loss if daily quest was not completed (25 HP loss per incomplete day)
        if (!_dailyQuest!.isCompleted) {
          _player.loseHpForTaskFailure(25);
        }
        _dailyQuest!.reset();
        // Save player after HP change
        await _persistenceService.savePlayer(_player);
      }
    }

    // Load challenges
    _challenges = await _persistenceService.loadChallenges();
    final activeChallengeId = await _persistenceService.loadActiveChallenge();
    if (activeChallengeId != null) {
      _activeChallenge = _challenges.firstWhere(
        (c) => c.id == activeChallengeId && !c.isCompleted,
        orElse: () => _challenges.firstWhere((c) => c.id == activeChallengeId),
      );
      // Check if challenge is expired (days are over)
      if (_activeChallenge != null && !_activeChallenge!.isCompleted) {
        final now = DateTime.now();
        final start = DateTime(_activeChallenge!.startDate.year, _activeChallenge!.startDate.month, _activeChallenge!.startDate.day);
        final current = DateTime(now.year, now.month, now.day);
        final daysElapsed = current.difference(start).inDays + 1;
        if (daysElapsed > _activeChallenge!.durationDays) {
          // Challenge expired - mark as completed and archived
          _activeChallenge!.isCompleted = true;
          _activeChallenge!.isArchived = true;
          _activeChallenge!.endDate = now;
          
          // Reset player streak and performance metrics when challenge expires
          _player.currentStreak = 0;
          _player.completedQuests = 0;
          _player.totalChallengesCompleted++;
          await _persistenceService.savePlayer(_player);
          
          _activeChallenge = null;
          await _persistenceService.saveActiveChallenge(null);
          await _saveChallenges();
        }
      }
    }

    // Load achievements
    _achievements = await _persistenceService.loadAchievements();
    if (_achievements.isEmpty) {
      _achievements = _initializeAchievements();
      await _persistenceService.saveAchievements(_achievements);
    }

    // Initialize Hunter's Journey
    if (_activeChallenge != null) {
      // Sync with active challenge
      _huntersJourney = HuntersJourney(
        totalDays: _activeChallenge!.durationDays,
        completedDays: _activeChallenge!.completedDays,
        startDate: _activeChallenge!.startDate,
      );
    } else {
      // No active challenge, use default
      _huntersJourney = HuntersJourney(
        completedDays: _player.completedQuests,
      );
    }

    setState(() => _isLoading = false);
    
    // Initialize periodic refresh timer to update time-based values
    if (_refreshTimer == null || !_refreshTimer!.isActive) {
      _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        if (mounted) {
          setState(() {
            // This triggers rebuilds to update daysLeft, daysRemaining, etc.
          });
        }
      });
    }
  }

  List<Achievement> _initializeAchievements() {
    return [
      Achievement(
        id: 'ach_1',
        title: 'First Steps',
        description: 'Complete your first task',
        icon: '🎯',
        requirement: 1,
      ),
      Achievement(
        id: 'ach_2',
        title: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        icon: '🔥',
        requirement: 7,
      ),
      Achievement(
        id: 'ach_3',
        title: 'Level Up',
        description: 'Reach level 5',
        icon: '⭐',
        requirement: 5,
      ),
      Achievement(
        id: 'ach_4',
        title: 'Challenge Master',
        description: 'Complete your first challenge',
        icon: '🏆',
        requirement: 1,
      ),
    ];
  }

  Future<void> _savePlayer() async {
    await _persistenceService.savePlayer(_player);
  }

  Future<void> _saveDailyQuest() async {
    if (_dailyQuest != null) {
      await _persistenceService.saveDailyQuest(_dailyQuest!);
    }
  }

  Future<void> _saveChallenges() async {
    await _persistenceService.saveChallenges(_challenges);
    if (_activeChallenge != null) {
      await _persistenceService.saveActiveChallenge(_activeChallenge!.id);
    } else {
      await _persistenceService.saveActiveChallenge(null);
    }
  }

  Future<void> _onStartChallenge() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChallengeScreen()),
    );
    
    if (result != null && result is Map<String, dynamic>) {
      final challenge = Challenge(
        id: 'challenge_${DateTime.now().millisecondsSinceEpoch}',
        title: '${result['duration']}-Day Challenge',
        durationDays: result['duration'] as int,
        taskNames: List<String>.from(result['tasks'] as List),
      );
      setState(() {
        _challenges.add(challenge);
        _activeChallenge = challenge;
        // Sync HuntersJourney with the new challenge
        _huntersJourney = HuntersJourney(
          totalDays: challenge.durationDays,
          completedDays: 0,
          startDate: challenge.startDate,
        );
        _dailyQuest = DailyQuest(
          id: 'quest_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Daily Tasks',
          tasks: challenge.taskNames.map((name) => QuestTask(
            id: 'task_${DateTime.now().millisecondsSinceEpoch}_${name}',
            name: name,
          )).toList(),
          timer: DailyTimer(),
        );
      });
      await _saveChallenges();
      await _saveDailyQuest();
    }
  }

  void _onViewQuest() {
    // Disabled: Do not show quest page as a pop-up or via navigation
  }

  Widget _buildCurrentScreen() {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.darkBackground,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryPurple),
        ),
      );
    }

    switch (_currentIndex) {
      case 0:
        // If there's an active challenge, redirect to quest screen instead of home
        if (_activeChallenge != null && !_activeChallenge!.isCompleted && _dailyQuest != null) {
          return QuestScreen(
            quest: _dailyQuest!,
            player: _player,
            onPlayerUpdate: (player) {
              setState(() {
                _player = player;
                _huntersJourney.completedDays = _player.completedQuests;
              });
              _savePlayer();
            },
            onQuestUpdate: (quest) {
              setState(() {
                _dailyQuest = quest;
                // Track challenge completion
                if (quest.isCompleted && _activeChallenge != null && !_activeChallenge!.isCompleted) {
                  _activeChallenge!.markDayCompleted(DateTime.now());
                  // Check if challenge is now completed
                  if (_activeChallenge!.isCompleted) {
                    // Reset player streak and performance metrics when challenge ends
                    _player.currentStreak = 0;
                    _player.completedQuests = 0;
                    _player.totalChallengesCompleted++;
                    _huntersJourney.resetJourney();
                    // Reset daily quest as well
                    _dailyQuest!.reset();
                    _activeChallenge = null;
                  }
                }
              });
              _savePlayer();
              _saveDailyQuest();
              _saveChallenges();
            },
          );
        }
        return HomeScreen(
          player: _player,
          activeChallenge: _activeChallenge,
          dailyQuest: _dailyQuest,
          onStartChallenge: _onStartChallenge,
          onViewQuest: _onViewQuest,
        );
      case 1:
        return DashboardScreen(
          player: _player,
          activeChallenge: _activeChallenge,
          huntersJourney: _huntersJourney,
        );
      case 2:
        return ProfileScreen(player: _player);
      case 3:
        return ChallengeHistoryScreen(challenges: _challenges);
      case 4:
        return AchievementsScreen(achievements: _achievements);
      default:
        // If there's an active challenge, redirect to quest screen instead of home
        if (_activeChallenge != null && !_activeChallenge!.isCompleted && _dailyQuest != null) {
          return QuestScreen(
            quest: _dailyQuest!,
            player: _player,
            onPlayerUpdate: (player) {
              setState(() {
                _player = player;
                _huntersJourney.completedDays = _player.completedQuests;
              });
              _savePlayer();
            },
            onQuestUpdate: (quest) {
              setState(() {
                _dailyQuest = quest;
                // Track challenge completion
                if (quest.isCompleted && _activeChallenge != null && !_activeChallenge!.isCompleted) {
                  _activeChallenge!.markDayCompleted(DateTime.now());
                  // Check if challenge is now completed
                  if (_activeChallenge!.isCompleted) {
                    // Reset player streak and performance metrics when challenge ends
                    _player.currentStreak = 0;
                    _player.completedQuests = 0;
                    _player.totalChallengesCompleted++;
                    _huntersJourney.resetJourney();
                    // Reset daily quest as well
                    _dailyQuest!.reset();
                    _activeChallenge = null;
                  }
                }
              });
              _savePlayer();
              _saveDailyQuest();
              _saveChallenges();
            },
          );
        }
        return HomeScreen(
          player: _player,
          activeChallenge: _activeChallenge,
          dailyQuest: _dailyQuest,
          onStartChallenge: _onStartChallenge,
          onViewQuest: _onViewQuest,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: _buildCurrentScreen(),
      ),
      bottomNavigationBar: _isLoading
          ? null
          : CustomBottomNavigation(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
    );
  }
}


