import 'package:countries_api/core/theme/app_theme.dart';
import 'package:countries_api/providers/country.dart';
import 'package:countries_api/providers/quiz.dart';
import 'package:countries_api/screens/quiz_play.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/locale_provider.dart';

class QuizConfigScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<QuizConfigScreen> createState() => _QuizConfigScreenState();
}

class _QuizConfigScreenState extends ConsumerState<QuizConfigScreen> {
  String _selectedDifficulty = 'easy';
  String _selectedContinent = 'All';

  @override
  Widget build(BuildContext context) {
    final countriesState = ref.watch(countryProvider);
    final continents = ['All', ...countriesState.value?.map((c) => c.continent).toSet() ??
        {}];
    final tr = ref.watch(trProvider);
    return Scaffold(
      appBar: AppBar(title: Text(tr('quiz_setup'))),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(tr('difficulty')),
            const SizedBox(height: 16),
            Row(
              children: ['easy', 'medium', 'hard'].map((diff) {
                final isSelected = _selectedDifficulty == diff;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDifficulty = diff),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.neonBlue.withOpacity(0.2) : AppTheme.darkSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppTheme.neonBlue : Colors.grey.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: isSelected ? [BoxShadow(color: AppTheme.neonBlue.withOpacity(0.4), blurRadius: 10, spreadRadius: 1)] : [],
                      ),
                      child: Center(
                        child: Text(
                          tr(diff),
                          style: TextStyle(
                            color: isSelected ? AppTheme.neonWhite : Colors.white70,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle(tr('continent')),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: continents.length,
                itemBuilder: (context, index) {
                  final cont = continents[index];
                  final isSelected = _selectedContinent == cont;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedContinent = cont),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.neonGreen.withValues(alpha: 0.15) : AppTheme.darkSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? AppTheme.neonGreen : Colors.grey.withValues(alpha: 0.3)),
                      ),
                      child: Center(
                        child: Text(
                          cont,
                          style: TextStyle(
                            color: isSelected ? AppTheme.neonWhite : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final countries = countriesState.value ?? [];
                  ref.read(quizProvider.notifier).startQuiz(countries, _selectedDifficulty, _selectedContinent);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const QuizPlayScreen()));
                },
                child: Text(tr('start_quiz')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(color: Colors.blueAccent, fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.bold),
    );
  }
}