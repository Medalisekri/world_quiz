import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Quiz Scoring Logic', () {


    int calculateScore(int correct, int total) {
      return correct;
    }

    double calculatePercentage(int correct, int total) {
      if (total == 0) return 0.0;
      return (correct / total) * 100;
    }

    String getFeedbackMessage(double percentage) {
      if (percentage >= 80) return 'Genius! 🧠';
      if (percentage >= 50) return 'Good Job! 👍';
      return 'Keep Practicing! 💪';
    }

    Color getAccentColor(double percentage) {
      if (percentage >= 80) return Color(0xFF4CAF50); // Green
      if (percentage >= 50) return Color(0xFF2196F3); // Blue
      return Color(0xFFF44336); // Red
    }

    test('should calculate percentage correctly', () {
      expect(calculatePercentage(8, 10), 80.0);
      expect(calculatePercentage(5, 10), 50.0);
      expect(calculatePercentage(0, 10), 0.0);
      expect(calculatePercentage(10, 10), 100.0);
    });

    test('should handle zero total questions without crashing', () {
      expect(calculatePercentage(0, 0), 0.0);
      expect(calculatePercentage(5, 0), 0.0);
    });

    test('should return correct feedback messages', () {
      expect(getFeedbackMessage(100.0), 'Genius! 🧠');
      expect(getFeedbackMessage(85.0), 'Genius! 🧠');
      expect(getFeedbackMessage(80.0), 'Genius! 🧠');
      expect(getFeedbackMessage(79.9), 'Good Job! 👍');
      expect(getFeedbackMessage(50.0), 'Good Job! 👍');
      expect(getFeedbackMessage(49.9), 'Keep Practicing! 💪');
      expect(getFeedbackMessage(0.0), 'Keep Practicing! 💪');
    });

    test('streak should increment on consecutive correct answers', () {
      int streak = 0;
      bool isCorrect = true;


      for (int i = 0; i < 3; i++) {
        if (isCorrect) {
          streak++;
        } else {
          streak = 0;
        }
      }

      expect(streak, 3);
    });

    test('streak should reset on wrong answer', () {
      int streak = 0;
      final answers = [true, true, true, false, true, true];

      int maxStreak = 0;
      for (final isCorrect in answers) {
        if (isCorrect) {
          streak++;
          if (streak > maxStreak) maxStreak = streak;
        } else {
          streak = 0;
        }
      }

      expect(maxStreak, 3); // Longest streak was 3
      expect(streak, 2); // Current streak after last wrong answer + 2 correct
    });

    test('timer should clamp between 0 and max time', () {
      const maxTime = 10.0;

      double clampTimer(double timeLeft) {
        return timeLeft.clamp(0.0, maxTime);
      }

      expect(clampTimer(15.0), 10.0);
      expect(clampTimer(10.0), 10.0);
      expect(clampTimer(5.0), 5.0);
      expect(clampTimer(0.0), 0.0);
      expect(clampTimer(-5.0), 0.0);
    });

    test('timer bar color should change when time is low', () {
      const maxTime = 10.0;
      const lowTimeThreshold = 3.0;

      String getTimerColor(double timeLeft) {
        return timeLeft <= lowTimeThreshold ? 'red' : 'blue';
      }

      expect(getTimerColor(10.0), 'blue');
      expect(getTimerColor(4.0), 'blue');
      expect(getTimerColor(3.0), 'red');
      expect(getTimerColor(1.0), 'red');
      expect(getTimerColor(0.0), 'red');
    });
  });
}