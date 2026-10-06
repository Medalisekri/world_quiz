import 'package:countries_api/models/country.dart';
import 'package:flutter/material.dart';

class CountryDetailScreen extends StatelessWidget {
  final Country? country;
  const CountryDetailScreen({super.key, this.country});

  @override
  Widget build(BuildContext context) {
    if (country == null) return const Scaffold();

    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return Scaffold(
      appBar: AppBar(title: const Text('WorldQuiz')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              country!.flagUrl,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(height: 220, color: surfaceColor, child: const Icon(Icons.flag, size: 80)),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(country!.name, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryColor.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(color: primaryColor.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(context, 'Capital', country!.capital),
                        const SizedBox(height: 16),
                        _buildDetailRow(context, 'Continent', country!.continent),
                        const SizedBox(height: 16),
                        _buildDetailRow(context, 'Population', country!.population.toString()),
                        const SizedBox(height: 16),
                        _buildDetailRow(context, 'Languages', country!.languages.join(', ')),
                        const SizedBox(height: 16),
                        _buildDetailRow(context, 'Currencies', country!.currencies.join(', ')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
        ),
        Expanded(
          child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}