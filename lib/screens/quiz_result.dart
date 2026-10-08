import 'package:confetti/confetti.dart';
import 'package:countries_api/core/theme/app_theme.dart';
import 'package:countries_api/providers/quiz.dart';
import 'package:countries_api/screens/quiz_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/locale_provider.dart';

class QuizResultScreen extends ConsumerStatefulWidget {
  const QuizResultScreen({super.key});
  @override
  ConsumerState<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends ConsumerState<QuizResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    final state = ref.read(quizProvider);
    if (state.score >= 7) {
      // Delay slightly so user sees the screen first
      Future.delayed(const Duration(milliseconds: 500), () {
        if(mounted) _confettiController.play();
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizProvider);
    final percentage = (state.score / state.questions.length) * 100;
    final tr = ref.watch(trProvider);
    // Determine message and color based on score
    String message;
    Color accentColor;
    if (percentage >= 80) {
      message = tr("genius! 🧠");
      accentColor = AppTheme.neonGreen;
    } else if (percentage >= 50) {
      message = tr("good_job! 👍");
      accentColor = AppTheme.neonBlue;
    } else {
      message = tr("keep_practicing! 💪");
      accentColor = AppTheme.neonRed;
    }

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(message, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: accentColor)),
                const SizedBox(height: 40),
                // Animated Score Counter
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: state.score),
                  duration: const Duration(seconds: 1, milliseconds: 500),
                  builder: (context, value, child) {
                    return RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: '$value', style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: accentColor)),
                          TextSpan(text:  '/ ${state.questions.length}', style: const TextStyle(fontSize: 40, color: Colors.blueAccent)),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                if (state.maxStreak > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.orange, size: 24),
                      const SizedBox(width: 8),
                      Text('${tr('max_streak')}: ${state.maxStreak}', style: const TextStyle(fontSize: 18, color: Colors.orange)),
                    ],
                  ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    // Reset provider and go back to config
                    ref.read(quizProvider.notifier).startQuiz([], 'easy', 'All'); // Quick reset
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QuizConfigScreen()));
                  },
                  child: Text(tr('play_again')),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  child: Text(tr('back_to_home'), style: const TextStyle(color: Colors.blueAccent)),
                ),
              ],
            ),
          ),
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [AppTheme.neonBlue, AppTheme.neonGreen, Colors.yellow, Colors.purple],
            ),
          ),
        ],
      ),
    );
  }
}