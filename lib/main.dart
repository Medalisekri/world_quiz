import 'package:countries_api/core/theme/app_theme.dart';
import 'package:countries_api/providers/locale_provider.dart';
import 'package:countries_api/providers/theme.dart';
import 'package:countries_api/repositories/cache.dart';
import 'package:countries_api/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await CacheRepository().init();
  runApp(const ProviderScope(child: App()));
}



  class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final themeMode = ref.watch(themeProvider);
  final locale = ref.watch(localeProvider);
  return MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: themeMode,
    locale: locale,
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),);}}
