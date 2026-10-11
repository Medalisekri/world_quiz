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
    try {
      final cachedData = await _cache.getCachedCountries();
      if (cachedData != null && cachedData.isNotEmpty) {
          final parsedCountries = cachedData.map((e) => Country.fromJson(e)).toList();
          return parsedCountries;
      }

      final countries = await _repository.fetchAllCountries();
      await _cache.saveCountries(countries);
      return countries.map((c)=>Country.fromJson(c)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

}

final countryProvider = AsyncNotifierProvider<CountryNotifier, List<Country>>(CountryNotifier.new);