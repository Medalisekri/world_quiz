import 'package:countries_api/models/country.dart';
import 'package:countries_api/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountryDetailScreen extends ConsumerWidget {
  final Country? country;
  const CountryDetailScreen({super.key, this.country});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    if (country == null) return const Scaffold();
     final tr = ref.watch(trProvider);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return Scaffold(
      appBar: AppBar(title: Text(tr('country_detail'))),
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
                        _buildDetailRow(context, tr('capital'), country!.capital),
                        const SizedBox(height: 16),
                        _buildDetailRow(context, tr('continent'), country!.continent),
                        const SizedBox(height: 16),
                        _buildDetailRow(context, tr('population'), country!.population.toString()),
                        const SizedBox(height: 16),
                        _buildDetailRow(context, tr('languages'), country!.languages.join(', ')),
                        const SizedBox(height: 16),
                        _buildDetailRow(context, tr('currencies'), country!.currencies.join(', ')),
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