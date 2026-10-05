import 'package:countries_api/models/country.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/cache.dart';
import '../repositories/country.dart';

class CountryNotifier extends AsyncNotifier<List<Country>> {
  late final CountryRepository _repository;
  late final CacheRepository _cache;

  @override
  Future<List<Country>> build() async {
    _repository = CountryRepository();
    _cache = CacheRepository();
    return _loadCountries();
  }

  Future<List<Country>> _loadCountries() async {
    // 1. Try to load from local cache first (instant load)
    final cachedData = await _cache.getCachedCountries();
    if (cachedData != null) {
      return cachedData.map((e) => Country.fromJson(e)).toList();
    }

    // 2. If no cache, fetch from API
    final countries = await _repository.fetchAllCountries();

    // 3. Save to cache for next time
    final rawDataForCache = countries.map((c) => c.toJson()).toList();
    await _cache.saveCountries(rawDataForCache);

    return countries;
  }

  // Optional: Allow manual refresh (e.g., pull-to-refresh)
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadCountries());
  }
}

final countryProvider = AsyncNotifierProvider<CountryNotifier, List<Country>>(CountryNotifier.new);