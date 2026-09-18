import 'package:flutter/material.dart';
import '../models/quest.dart';
import '../models/player.dart';
import '../widgets/player_status_card.dart';
import '../widgets/daily_timer_widget.dart';
import '../theme/app_theme.dart';
import 'dart:async';
import 'dart:ui';

class QuestScreen extends StatefulWidget {
  final DailyQuest quest;
  final Player player;
  final Function(Player)? onPlayerUpdate;
  final Function(DailyQuest)? onQuestUpdate;

  const QuestScreen({
    super.key,
    required this.quest,
    required this.player,
    this.onPlayerUpdate,
    this.onQuestUpdate,
  });

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> with TickerProviderStateMixin {
  late DailyQuest _quest;
  late Player _player;
  late AnimationController _levelUpAnimationController;
  late Animation<double> _levelUpAnimation;
  late AnimationController _fullScreenAnimationController;
  late Animation<double> _fullScreenScaleAnimation;
  late Animation<double> _fullScreenOpacityAnimation;
  int _previousLevel = 0;

  @override
  void initState() {
    super.initState();
    _quest = widget.quest;
    _player = widget.player;
    _previousLevel = _player.level;
    
    // Initialize level-up animation for card
    _levelUpAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _levelUpAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _levelUpAnimationController, curve: Curves.elasticOut),
    );
    
    // Initialize full-screen animation
    _fullScreenAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fullScreenScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _fullScreenAnimationController, curve: Curves.elasticOut),
    );
    
    _fullScreenOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fullScreenAnimationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _levelUpAnimationController.dispose();
    _fullScreenAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(QuestScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if player level has increased
    if (_player.level > _previousLevel) {
      _levelUpAnimationController.forward().then((_) {
        _levelUpAnimationController.reverse();
      });
      _previousLevel = _player.level;
    }
  }

  void _handleTaskComplete(int index) {
    setState(() {
      if (!_quest.tasks[index].isCompleted && _quest.tasks[index].canCompleteToday()) {
        _quest.completeTask(index);
        widget.onPlayerUpdate?.call(_player);
        widget.onQuestUpdate?.call(_quest);
        // Check if all tasks are now completed
        if (_quest.isCompleted) {
          _handleQuestComplete();
        }
      }
    });
  }

  void _handleQuestComplete() {
    setState(() {
      _player.gainExp(75);
      _player.gainHpForTaskComplete(25); // Gain 25 HP for completing the entire daily quest
      _player.completeQuest();
      widget.onPlayerUpdate?.call(_player);
      widget.onQuestUpdate?.call(_quest);
      // Check for level-up
      if (_player.level > _previousLevel) {
        _levelUpAnimationController.forward().then((_) {
          _levelUpAnimationController.reverse();
        });
        _previousLevel = _player.level;
        _showLevelUpNotification();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daily quest completed! You gained 75 EXP!'),
        backgroundColor: AppTheme.primaryMagenta,
      ),
    );
  }

  void _showLevelUpNotification() {
    _fullScreenAnimationController.reset();
    _fullScreenAnimationController.forward();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        // Auto-close dialog after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
          }
        });
        
        return AnimatedBuilder(
          animation: _fullScreenAnimationController,
          builder: (context, child) {
            return WillPopScope(
              onWillPop: () async => true,
              child: Stack(
                children: [
                  // Blurred background
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10.0 * _fullScreenOpacityAnimation.value,
                        sigmaY: 10.0 * _fullScreenOpacityAnimation.value,
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.4 * _fullScreenOpacityAnimation.value),
                      ),
                    ),
                  ),
                  // Centered level-up content
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // "LEVEL UP!" text with scale animation
                        ScaleTransition(
                          scale: _fullScreenScaleAnimation,
                          child: Text(
                            'LEVEL UP!',
                            style: const TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFD700),
                              letterSpacing: 3,
                              shadows: [
                                Shadow(
                                  color: Color(0xFFFFD700),
                                  blurRadius: 25,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        // Level circle and arrow side by side
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Level display with background
                            ScaleTransition(
                              scale: _fullScreenScaleAnimation,
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color(0xFFFFD700).withOpacity(0.3),
                                      const Color(0xFF00BCD4).withOpacity(0.1),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFFFFD700),
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFFD700).withOpacity(0.6),
                                      blurRadius: 30,
                                      spreadRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '${_player.level}',
                                    style: const TextStyle(
                                      fontSize: 120,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFD700),
                                      shadows: [
                                        Shadow(
                                          color: Color(0xFFFFD700),
                                          blurRadius: 20,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 40),
                            // Upward arrow on the right
                            ScaleTransition(
                              scale: _fullScreenScaleAnimation,
                              child: Transform.translate(
                                offset: Offset(_fullScreenOpacityAnimation.value * 15, 0),
                                child: const Icon(
                                  Icons.arrow_upward,
                                  size: 96,
                                  color: Color(0xFFFFD700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  int _getTaskCount(String taskName) {
    // Implement your logic for task count if needed
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F6B6B),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Main Quest Panel
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0F6B6B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF00BCD4),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00BCD4).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lock Warning Box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B7500).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFD4AF37),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock,
                            color: Color(0xFFD4AF37),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Quest page locked - Complete your daily challenge',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFFD4AF37),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // QUEST INFO Section
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF00BCD4),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info,
                            color: Color(0xFF00BCD4),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'QUEST INFO',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF00BCD4),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Daily Timer Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B5B2E).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFD4AF37),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule,
                                color: Color(0xFFD4AF37),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'DAILY TIMER',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: const Color(0xFFD4AF37),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (_quest.timer != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: DailyTimerWidget(timer: _quest.timer!),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Quest Title
                    Text(
                      '[Daily Quest: ${_quest.title}]',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF00BCD4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // GOAL Section
                    Text(
                      'GOAL',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF00BCD4),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Tasks List
                    ..._quest.tasks.asMap().entries.map((entry) {
                      final index = entry.key;
                      final task = entry.value;
                      final canClickToday = task.canCompleteToday() && !_quest.completedToday;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: canClickToday ? () => _handleTaskComplete(index) : null,
                          child: Opacity(
                            opacity: canClickToday ? 1.0 : 0.5,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    task.name,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFF00BCD4),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '[${task.isCompleted ? _getTaskCount(task.name) : 0}/${_getTaskCount(task.name)}]',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF00BCD4).withOpacity(0.7),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: task.isCompleted 
                                      ? const Color(0xFF1B5E5E)
                                      : Colors.transparent,
                                    border: Border.all(
                                      color: task.isCompleted
                                        ? const Color(0xFF1B5E5E)
                                        : (canClickToday ? const Color(0xFF00BCD4).withOpacity(0.7) : const Color(0xFF00BCD4).withOpacity(0.3)),
                                      width: 2,
                                    ),
                                  ),
                                  child: task.isCompleted
                                    ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                    : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    // WARNING Message
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B4545).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE63946).withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFFE63946),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                          children: const [
                            TextSpan(text: 'WARNING: Failure to complete the daily quest will result in an appropriate '),
                            TextSpan(
                              text: 'penalty.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Complete Button
                        GestureDetector(
                          onTap: _quest.completedToday ? null : () {
                            setState(() {
                              for (var i = 0; i < _quest.tasks.length; i++) {
                                if (!_quest.tasks[i].isCompleted) {
                                  _quest.completeTask(i);
                                }
                              }
                              _quest.isCompleted = true;
                              _quest.completedDate = DateTime.now();
                            });
                            _handleQuestComplete();
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _quest.completedToday 
                                  ? const Color(0xFF00BCD4).withOpacity(0.3)
                                  : const Color(0xFF00BCD4),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.check,
                              size: 40,
                              color: _quest.completedToday 
                                ? const Color(0xFF4CAF50).withOpacity(0.5)
                                : const Color(0xFF00BCD4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 60),
                        // Fail Button
                        GestureDetector(
                          onTap: _quest.completedToday ? null : () {
                            // Handle fail quest
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Quest abandoned but u have time left.'),
                                backgroundColor: Color(0xFFE63946),
                              ),
                            );
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _quest.completedToday
                                  ? const Color(0xFFE63946).withOpacity(0.3)
                                  : const Color(0xFFE63946),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.close,
                              size: 40,
                              color: _quest.completedToday
                                ? const Color(0xFFE63946).withOpacity(0.5)
                                : const Color(0xFFE63946),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Status
                    Center(
                      child: Text(
                        _quest.completedToday
                          ? 'Status: COMPLETED TODAY'
                          : 'Status: ${_quest.isCompleted ? 'COMPLETED' : 'ACTIVE'}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: _quest.completedToday
                            ? const Color(0xFF4CAF50)
                            : _quest.isCompleted ? const Color(0xFF4CAF50) : const Color(0xFFD4AF37),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Player Status Card at the end
              PlayerStatusCard(
                player: _player,
                levelUpAnimation: _levelUpAnimation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
