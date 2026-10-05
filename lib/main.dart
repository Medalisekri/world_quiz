import 'package:countries_api/repositories/cache.dart';
import 'package:countries_api/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // Initialize Hive caching
  await CacheRepository().init();

  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          textTheme: GoogleFonts.poppinsTextTheme(),
          brightness: Brightness.dark, // Setting base to dark for your preferred theme
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(), // Use home instead of routes for simpler splash flow
      ),
    ),
  );
}