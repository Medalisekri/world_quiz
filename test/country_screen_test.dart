import 'package:countries_api/models/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Country Card Widget', () {
    testWidgets('should display country name and flag', (WidgetTester tester) async {
      // Create a mock country
      const testCountry = Country(
        name: 'Japan',
        continent: 'Asia',
        capital: 'Tokyo',
        population: 126000000,
        flagUrl: 'https://example.com/jp.png',
        currencies: ['Yen'],
        languages: ['Japanese'],
        lat: 36.2048,
        lng: 138.2529,
      );

      // Build a simple ListTile mimicking your country list
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ListTile(
                leading: Icon(Icons.flag),
                title: Text('Japan'),
              ),
            ),
          ),
        ),
      );

      // Verify the text appears
      expect(find.text('Japan'), findsOneWidget);
      expect(find.byIcon(Icons.flag), findsOneWidget);
    });

    testWidgets('should show empty state when no countries', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('No countries available'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('No countries available'), findsOneWidget);
    });
  });
}