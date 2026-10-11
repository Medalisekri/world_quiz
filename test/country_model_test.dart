import 'package:countries_api/models/country.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Country.fromJson', () {
    test('should parse raw API data correctly', () {
      // This is the format the REST Countries API returns
      final apiJson = {
        'names': {'common': 'France'},
        'continents': ['Europe'],
        'capitals': [{'name': 'Paris'}],
        'population': 67390000,
        'flag': {'url_png': 'https://example.com/fr.png'},
        'currencies': [
          {'code': 'EUR', 'name': 'Euro', 'symbol': '€'}
        ],
        'languages': [
          {
            'bcp47': 'fr',
            'iso639_1': 'fr',
            'name': 'French',
            'native_name': 'français'
          }
        ],
        'coordinates': {'lat': 46.227638, 'lng': 2.213749},
      };

      final country = Country.fromJson(apiJson);

      expect(country.name, 'France');
      expect(country.continent, 'Europe');
      expect(country.capital, 'Paris');
      expect(country.population, 67390000);
      expect(country.currencies, ['Euro']);
      expect(country.languages, ['French']);
      expect(country.lat, 46.227638);
      expect(country.lng, 2.213749);
    });

    test('should handle missing optional fields gracefully', () {
      // Test with minimal data — no crashes
      final minimalJson = {
        'names': {'common': 'Unknown Land'},
      };

      final country = Country.fromJson(minimalJson);

      expect(country.name, 'Unknown Land');
      expect(country.currencies, isEmpty);
      expect(country.languages, isEmpty);
      expect(country.lat, 0.0);
      expect(country.lng, 0.0);
    });

    test('should correctly parse currencies as list of maps', () {
      final jsonWithMultipleCurrencies = {
        'names': {'common': 'Test'},
        'currencies': [
          {'code': 'USD', 'name': 'Dollar'},
          {'code': 'EUR', 'name': 'Euro'},
        ],
      };

      final country = Country.fromJson(jsonWithMultipleCurrencies);

      expect(country.currencies.length, 2);
      expect(country.currencies, contains('Dollar'));
      expect(country.currencies, contains('Euro'));
    });
  });
}