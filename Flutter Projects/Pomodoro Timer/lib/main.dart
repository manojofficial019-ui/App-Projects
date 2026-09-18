import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro Timer',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const PomodoroHome(),
    );
  }
}

class PomodoroHome extends StatefulWidget {
  const PomodoroHome({super.key});

  @override
  State<PomodoroHome> createState() => _PomodoroHomeState();
}

class _PomodoroHomeState extends State<PomodoroHome>
    with SingleTickerProviderStateMixin {
  static const int workMinutes = 25;
  static const int breakMinutes = 5;

  int minutes = workMinutes;
  int seconds = 0;
  bool isRunning = false;
  bool isWork = true;
  Timer? timer;
  late AnimationController _animationController;
  
  // AdMob
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _loadBannerAd();
    _loadInterstitialAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ad unit ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd?.load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ad unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd?.setImmersiveMode(true);
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          _loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  void startTimer() {
    if (isRunning) return;
    setState(() => isRunning = true);
    _animationController.repeat();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (seconds == 0) {
          if (minutes == 0) {
            // Play system beep
            SystemSound.play(SystemSoundType.alert);

            // Show interstitial ad when timer completes
            _showInterstitialAd();

            // Switch mode
            isWork = !isWork;
            minutes = isWork ? workMinutes : breakMinutes;
            seconds = 0;
          } else {
            minutes--;
            seconds = 59;
          }
        } else {
          seconds--;
        }
      });
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
    _animationController.stop();
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      isWork = true;
      minutes = workMinutes;
      seconds = 0;
    });
    _animationController.reset();
  }

  String timeText() {
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  double get progress {
    int totalSeconds = (isWork ? workMinutes : breakMinutes) * 60;
    int currentSeconds = minutes * 60 + seconds;
    return 1.0 - (currentSeconds / totalSeconds);
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalSeconds = (isWork ? workMinutes : breakMinutes) * 60;
    final currentSeconds = minutes * 60 + seconds;
    final progressValue = 1.0 - (currentSeconds / totalSeconds);

    final gradientColors = isWork
        ? [Colors.red.shade400, Colors.red.shade700]
        : [Colors.green.shade400, Colors.green.shade700];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gradientColors[0].withOpacity(0.1),
              gradientColors[1].withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Main Timer Section
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Mode Text
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: gradientColors[0].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: gradientColors[0].withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          isWork ? "WORK TIME" : "BREAK TIME",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: gradientColors[1],
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Circular Progress Timer
                      SizedBox(
                        width: 280,
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background Circle
                            Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: gradientColors[0].withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                            // Progress Circle
                            SizedBox(
                              width: 280,
                              height: 280,
                              child: CircularProgressIndicator(
                                value: progressValue,
                                strokeWidth: 12,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  gradientColors[1],
                                ),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            // Time Text
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  timeText(),
                                  style: TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold,
                                    color: gradientColors[1],
                                    height: 1.0,
                                  ),
                                ),
                                if (isRunning)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          gradientColors[1],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      
                      // Control Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildActionButton(
                            icon: Icons.play_arrow,
                            label: "Start",
                            onPressed: startTimer,
                            color: Colors.green,
                            isEnabled: !isRunning,
                          ),
                          const SizedBox(width: 16),
                          _buildActionButton(
                            icon: Icons.pause,
                            label: "Pause",
                            onPressed: pauseTimer,
                            color: Colors.orange,
                            isEnabled: isRunning,
                          ),
                          const SizedBox(width: 16),
                          _buildActionButton(
                            icon: Icons.refresh,
                            label: "Reset",
                            onPressed: resetTimer,
                            color: Colors.blue,
                            isEnabled: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Banner Ad
              if (_isBannerAdReady && _bannerAd != null)
                Container(
                  alignment: Alignment.center,
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    required bool isEnabled,
  }) {
    return Column(
      children: [
        Material(
          color: isEnabled ? color : Colors.grey,
          borderRadius: BorderRadius.circular(16),
          elevation: isEnabled ? 4 : 0,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isEnabled ? color : Colors.grey,
          ),
        ),
      ],
    );
  }
}
