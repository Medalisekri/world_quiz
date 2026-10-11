import 'package:countries_api/providers/country.dart';
import 'package:countries_api/screens/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen(countryProvider, (previous, next) {
      if (!next.isLoading && next.hasValue && next.value!.isNotEmpty) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>CountryScreen()));
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'lib/core/assets/images/earth.png',
                width: 130,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.public, size: 100, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 32),
              CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }
}