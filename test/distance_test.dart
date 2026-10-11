import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('Map Distance Calculation', () {

    const Distance distance = Distance();

    test('should calculate distance between Paris and Berlin', () {
      const paris = LatLng(48.8566, 2.3522);
      const berlin = LatLng(52.5200, 13.4050);

      final km = distance.as(LengthUnit.Kilometer, paris, berlin).round();

      // Real distance is approximately 878 km
      expect(km, greaterThan(850));
      expect(km, lessThan(900));
    });

    test('should return 0 for same location', () {
      const tokyo = LatLng(35.6762, 139.6503);

      final km = distance.as(LengthUnit.Kilometer, tokyo, tokyo);

      expect(km, 0.0);
    });

    test('should correctly determine if within threshold', () {
      const target = LatLng(48.8566, 2.3522); // Paris
      const closeGuess = LatLng(48.9, 2.4); // Nearby
      const farGuess = LatLng(35.6762, 139.6503); // Tokyo

      final closeDistance = distance.as(LengthUnit.Kilometer, target, closeGuess);
      final farDistance = distance.as(LengthUnit.Kilometer, target, farGuess);

      expect(closeDistance, lessThan(800)); // Within quiz threshold
      expect(farDistance, greaterThan(800)); // Outside quiz threshold
    });

    test('should handle antimeridian crossing', () {
      // Testing locations near the international date line
      const fiji = LatLng(-17.7134, 178.0650);
      const samoa = LatLng(-13.7590, -172.1046);

      final km = distance.as(LengthUnit.Kilometer, fiji, samoa);

      // Should calculate correctly across the date line
      expect(km, greaterThan(0));
      expect(km, lessThan(2000));
    });

    test('should handle poles correctly', () {
      const northPole = LatLng(90.0, 0.0);
      const southPole = LatLng(-90.0, 0.0);

      final km = distance.as(LengthUnit.Kilometer, northPole, southPole);

      // Should be approximately half the Earth circumference
      expect(km, greaterThan(19000));
      expect(km, lessThan(21000));
    });
  });
}