import 'package:countries_api/providers/country.dart';
import 'package:countries_api/providers/locale_provider.dart';
import 'package:countries_api/screens/country_detail.dart';
import 'package:countries_api/screens/quiz_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme.dart';

class CountryScreen extends ConsumerStatefulWidget {
  const CountryScreen({super.key});
  @override
  ConsumerState<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends ConsumerState<CountryScreen> {
  String selectedContinent = 'All';

  @override
  Widget build(BuildContext context) {
    final countriesState = ref.watch(countryProvider);
    final themeMode = ref.watch(themeProvider);
    final tr = ref.watch(trProvider);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;

    if (countriesState.isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator(color: primaryColor)));
    }

    if (countriesState.hasError) {
      return Scaffold(
        appBar: AppBar(title: Text(tr('app_title'))),
        body: Center(
          child: Text(countriesState.error.toString(), style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 18)),
        ),
      );
    }

    final countries = countriesState.value ?? [];
    final continents = ['All', ...countries.map((c) => c.continent).toSet()];
    final filtered = selectedContinent == 'All' ? countries : countries.where((c) => c.continent == selectedContinent).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('app_title')),
        actions: [
          IconButton(
            icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: () {
              ref.read(localeProvider.notifier).toggleLocale();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Continent Filter Pills
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: continents.length,
                itemBuilder: (context, index) {
                  final cont = continents[index];
                  final isSelected = selectedContinent == cont;
                  return GestureDetector(
                    onTap: () => setState(() => selectedContinent = cont),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor.withOpacity(0.15) : surfaceColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? primaryColor : Colors.transparent),
                      ),
                      child: Center(
                        child: Text(
                          cont,
                          style: TextStyle(
                            color: isSelected ? primaryColor : textColor.withOpacity(0.7),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Country List
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final country = filtered[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CountryDetailScreen(country: country))),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          country.flagUrl,
                          width: 50,
                          height: 35,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.flag),
                        ),
                      ),
                      title: Text(country.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      trailing: Icon(Icons.chevron_right, color: textColor.withOpacity(0.5)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context , MaterialPageRoute(builder: (_)=>QuizConfigScreen())),
        label: Text(tr('quiz')),
        icon: const Icon(Icons.quiz),
      ),
    );
  }
}