import 'dart:async';
import 'package:countries_api/core/theme/app_theme.dart';
import 'package:countries_api/models/country.dart';
import 'package:countries_api/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../providers/quiz.dart';

class MapQuizScreen extends ConsumerStatefulWidget {
  final List<Country> countries;
  const MapQuizScreen({super.key, required this.countries});

  @override
  ConsumerState<MapQuizScreen> createState() => _MapQuizScreenState();
}

class _MapQuizScreenState extends ConsumerState<MapQuizScreen> {
  late Country targetCountry;
  LatLng? tappedLocation;
  bool answered = false;
  int score = 0;
  int questionIndex = 0;
  int distanceKm = 0;
  final List<Country> quizCountries = [];

  Timer? _timer;
  int _timeLeft = 15;

  @override
  void initState() {
    super.initState();
    _generateMapQuiz();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _generateMapQuiz() {
    final shuffled = List<Country>.from(widget.countries)..shuffle();
    final validCountries = shuffled.where((c) => c.lat != 0 && c.lng != 0).toList();
    quizCountries.addAll(validCountries.take(5));
    targetCountry = quizCountries[0];
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0 && !answered) {
        setState(() => _timeLeft--);
      } else if (_timeLeft == 0 && !answered) {
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    _timer?.cancel();
    setState(() {
      answered = true;
      distanceKm = 99999;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _nextQuestion();
    });
  }

  void _handleTap(LatLng tapPos) {
    if (answered) return;
    _timer?.cancel();

    final actualLatLng = LatLng(targetCountry.lat, targetCountry.lng);

    setState(() {
      tappedLocation = tapPos;
      answered = true;
      distanceKm = const Distance().as(LengthUnit.Kilometer, tapPos, actualLatLng).round();
    });

    if (distanceKm <= 800) score++;

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (questionIndex + 1 >= quizCountries.length) {
      _timer?.cancel();
      _showResultsDialog();
      return;
    }

    setState(() {
      questionIndex++;
      targetCountry = quizCountries[questionIndex];
      tappedLocation = null;
      answered = false;
      distanceKm = 0;
    });
    _startTimer();
  }

  void _showResultsDialog() {
    final tr = ref.read(trProvider);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: Text(tr('quiz_setup'), style: const TextStyle(color: Colors.white)),
        content: Text(
          '$score / ${quizCountries.length}',
          style: TextStyle(color: AppTheme.neonGreen, fontSize: 32, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: Text(tr('back_to_home')),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = ref.watch(trProvider);
    final actualLatLng = LatLng(targetCountry.lat, targetCountry.lng);
    final isCorrect = distanceKm <= 800 && distanceKm != 99999;
    final cartoApiKey = dotenv.env['CARTO_API_KEY'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text('${tr('question')} ${questionIndex + 1}/5'),
      ),
      body: Column(
        children: [
          Builder(
            builder: (context) {
              final percentage = _timeLeft / 15.0;
              final color = _timeLeft <= 5.0 ? AppTheme.neonRed : AppTheme.neonBlue;
              return Container(
                height: 8,
                width: double.infinity,
                color: AppTheme.darkSurface,
                child: FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: percentage.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      boxShadow: [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 10, spreadRadius: 2)],
                    ),
                  ),
                ),
              );
            },
          ),


          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: const LatLng(20, 0),
                    initialZoom: 2,
                    onTap: (_, tapPos) => _handleTap(tapPos),
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag | InteractiveFlag.flingAnimation,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png?key=$cartoApiKey',
                      userAgentPackageName: 'com.example.countries_api',
                    ),
                    if (tappedLocation != null)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [tappedLocation!, actualLatLng],
                            strokeWidth: 3.0,
                            color: isCorrect ? AppTheme.neonGreen : AppTheme.neonRed,
                          ),
                        ],
                      ),
                    if (tappedLocation != null) ...[
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: tappedLocation!,
                            width: 20,
                            height: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isCorrect ? AppTheme.neonGreen : AppTheme.neonRed,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (isCorrect ? AppTheme.neonGreen : AppTheme.neonRed).withValues(alpha: 0.8),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (!isCorrect)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: actualLatLng,
                              width: 20,
                              height: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.neonBlue,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.neonBlue.withValues(alpha: 0.8),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ]
                  ],
                ),

                // Top Overlay (Country Name & Distance)
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.darkSurface.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.neonBlue, width: 2),
                      boxShadow: [BoxShadow(color: AppTheme.neonBlue.withOpacity(0.3), blurRadius: 15)],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(tr('quiz'), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                        const SizedBox(height: 8),
                        Text(
                          targetCountry.name,
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        if (answered)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              distanceKm == 99999 ? tr("time_up") : "$distanceKm km",
                              style: TextStyle(
                                color: isCorrect ? AppTheme.neonGreen : AppTheme.neonRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}