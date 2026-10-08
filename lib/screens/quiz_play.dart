import 'dart:math' as math;
import 'package:countries_api/core/theme/app_theme.dart';
import 'package:countries_api/providers/quiz.dart';
import 'package:countries_api/screens/quiz_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizPlayScreen extends ConsumerStatefulWidget {
  const QuizPlayScreen({super.key});
  @override
  ConsumerState<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends ConsumerState<QuizPlayScreen> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizProvider);

    ref.listen<QuizState>(quizProvider, (prev, next) {
      if (next.isFinished == true) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  QuizResultScreen()));
      }
      else if (next.answered && !(prev?.answered ?? false)) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted && ref.read(quizProvider).answered) {
            ref.read(quizProvider.notifier).nextQuestion();
          }
        });
      }
    });

    if (state.questions.isEmpty) return const Scaffold();

    final currentQ = state.questions[state.currentIndex];
    final isFlag = currentQ.question.startsWith('http');
    final progress = (state.currentIndex + 1) / state.questions.length;
    return Scaffold(
      appBar: AppBar(
        title: Text('${state.currentIndex + 1} / ${state.questions.length}'),
        actions: [
          if (state.streak > 1)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                    Text(' ${state.streak}', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
        ],
      ),
      body: Column(
        children: [
          // Smooth Timer Bar
          Builder(
            builder: (context) {
              final percentage = state.timeLeft / 12.0;
              final color = state.timeLeft <= 3.0 ? AppTheme.neonRed : AppTheme.neonBlue;
              return Container(
                height: 8,
                width: double.infinity,
                color: AppTheme.darkSurface,
                child: FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: percentage.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      boxShadow: [BoxShadow(color: color.withOpacity(0.6), blurRadius: 10, spreadRadius: 2)],
                    ),
                  ),
                ),
              );
            },
          ),
          LinearProgressIndicator(value: progress, backgroundColor: Colors.transparent, color: AppTheme.neonGreen, minHeight: 2),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isFlag
                        ? Image.network(currentQ.question, key: ValueKey(currentQ.question), height: 200, errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 80))
                        : Text(currentQ.question, key: ValueKey(currentQ.question), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent), textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 48),
                  ...currentQ.options.map((option) {
                    return _buildOptionButton(context, option, currentQ.correctAnswer, state.answered, state.selectedAnswer);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String option, String correctAnswer, bool answered, String? selectedAnswer) {
    final isCorrect = option == correctAnswer;
    final isSelected = option == selectedAnswer;

    Color borderColor = Colors.grey.withOpacity(0.3);
    Color textColor = Colors.white70;
    Color? glowColor;
    bool shouldShake = false;

    if (answered) {
      if (isCorrect) {
        borderColor = AppTheme.neonGreen;
        textColor = AppTheme.neonGreen;
        glowColor = AppTheme.neonGreen;
      } else if (isSelected) {
        // User picked this, and it's WRONG
        borderColor = AppTheme.neonRed;
        textColor = AppTheme.neonRed;
        glowColor = AppTheme.neonRed;
        shouldShake = true;
      } else {
        // Dim other wrong answers
        borderColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.white24;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () {
          if (!answered) {
            ref.read(quizProvider.notifier).answerQuestion(option);
            if (!isCorrect) _triggerShake(); // Trigger shake if wrong
          }
        },
        child: AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            double offset = 0;
            if (shouldShake && _shakeController.isAnimating) {
              offset = 10 * math.sin(_shakeController.value * math.pi * 4);
            }
            return Transform.translate(
              offset: Offset(offset, 0),
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: AppTheme.darkSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 2),
              boxShadow: glowColor != null ? [BoxShadow(color: glowColor.withOpacity(0.5), blurRadius: 15, spreadRadius: 2)] : [],
            ),
            child: Center(
              child: Text(option, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }
}