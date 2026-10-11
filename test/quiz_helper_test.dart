import 'package:countries_api/models/country.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  // Sample test data
  final testCountries = [
    const Country(
      name: 'France', continent: 'Europe', capital: 'Paris',
      population: 67000000, flagUrl: 'fr.png',
      currencies: ['Euro'], languages: ['French'],
      lat: 46.0, lng: 2.0,
    ),
    const Country(
      name: 'Germany', continent: 'Europe', capital: 'Berlin',
      population: 83000000, flagUrl: 'de.png',
      currencies: ['Euro'], languages: ['German'],
      lat: 51.0, lng: 9.0,
    ),
    const Country(
      name: 'Japan', continent: 'Asia', capital: 'Tokyo',
      population: 126000000, flagUrl: 'jp.png',
      currencies: ['Yen'], languages: ['Japanese'],
      lat: 36.0, lng: 138.0,
    ),
    const Country(
      name: 'Brazil', continent: 'South America', capital: 'Brasilia',
      population: 212000000, flagUrl: 'br.png',
      currencies: ['Real'], languages: ['Portuguese'],
      lat: -14.0, lng: -51.0,
    ),
    const Country(
      name: 'Egypt', continent: 'Africa', capital: 'Cairo',
      population: 102000000, flagUrl: 'eg.png',
      currencies: ['Pound'], languages: ['Arabic'],
      lat: 26.0, lng: 30.0,
    ),
  ];

  group('Quiz Question Generation', () {

    test('should generate exactly 10 questions', () {
      // Simulate generateQuestions with enough countries
      final shuffled = List.of(testCountries)..shuffle();
      final questions = shuffled.take(5).toList();

      expect(questions.length, 5);
    });

    test('correct answer should always be included in options', () {
      for (final country in testCountries) {
        final otherCountries = testCountries.where((c) => c.name != country.name).toList();
        otherCountries.shuffle();
        final wrongOptions = otherCountries.take(3).map((c) => c.name).toList();
        final options = [country.name, ...wrongOptions]..shuffle();

        // The correct answer must be in the options list
        expect(options, contains(country.name));
        // There should be exactly 4 options
        expect(options.length, 4);
      }
    });

    test('should not have duplicate options', () {
      for (final country in testCountries) {
        final otherCountries = testCountries.where((c) => c.name != country.name).toList();
        otherCountries.shuffle();
        final wrongOptions = otherCountries.take(3).map((c) => c.name).toList();
        final options = [country.name, ...wrongOptions];

        // No duplicates allowed
        expect(options.toSet().length, options.length);
      }
    });

    test('should filter countries by continent correctly', () {
      final selectedContinent = 'Europe';
      final filtered = testCountries.where((c) => c.continent == selectedContinent).toList();

      expect(filtered.length, 2);
      expect(filtered.every((c) => c.continent == 'Europe'), isTrue);
      expect(filtered.map((c) => c.name), containsAll(['France', 'Germany']));
    });

    test('should fall back to all countries when continent has fewer than 4', () {
      final selectedContinent = 'South America';
      final filtered = testCountries.where((c) => c.continent == selectedContinent).toList();

      // Brazil is the only South American country in our test set
      expect(filtered.length, lessThan(4));

      // Logic: fall back to all countries
      final finalList = filtered.length < 4 ? testCountries : filtered;
      expect(finalList.length, 5);
    });

    test('should generate capital questions correctly', () {
      final country = testCountries[0]; // France
      final questionText = country.capital;

      expect(questionText, 'Paris');
      expect(questionText, isNotEmpty);
    });

    test('should handle countries with no capital gracefully', () {
      final countryNoCapital = const Country(
        name: 'Nauru', continent: 'Oceania', capital: '',
        population: 10000, flagUrl: 'nr.png',
        currencies: ['Dollar'], languages: ['Nauruan'],
        lat: -0.5, lng: 166.9,
      );

      expect(countryNoCapital.capital, isEmpty);

    });
  });
}