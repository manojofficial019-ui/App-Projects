import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/player.dart';
import '../models/challenge.dart';
import '../models/quest.dart';
import '../widgets/player_status_card.dart';
import 'challenge_screen.dart';

class HomeScreen extends StatelessWidget {
  final Player player;
  final Challenge? activeChallenge;
  final DailyQuest? dailyQuest;
  final Future<void> Function()? onStartChallenge;
  final VoidCallback? onViewQuest;

  const HomeScreen({
    super.key,
    required this.player,
    this.activeChallenge,
    this.dailyQuest,
    this.onStartChallenge,
    this.onViewQuest,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          // Full screen background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/other/homescreen.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content on top with SafeArea
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Button and Player Status centered
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Start New Challenge Button
                      GestureDetector(
                        onTap: activeChallenge != null && !activeChallenge!.isCompleted
                            ? null
                            : () async {
                                final callback = onStartChallenge;
                                if (callback != null) {
                                  await callback();
                                } else {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ChallengeScreen()),
                                  );
                                }
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: activeChallenge != null && !activeChallenge!.isCompleted
                                ? LinearGradient(
                                    colors: [
                                      AppTheme.cardBorder.withOpacity(0.6),
                                      AppTheme.cardBorder.withOpacity(0.4),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : LinearGradient(
                                    colors: [
                                      AppTheme.primaryMagenta,
                                      AppTheme.primaryMagenta.withOpacity(0.95),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryMagenta.withOpacity(0.7),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 24,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                activeChallenge != null && !activeChallenge!.isCompleted
                                    ? 'Challenge Active'
                                    : 'Start New Challenge',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Player Status Card
                      PlayerStatusCard(player: player),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

