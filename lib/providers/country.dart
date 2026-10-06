import 'package:countries_api/models/country.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
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
    final cachedData = await _cache.getCachedCountries();
    if (cachedData != null) {
      try{
      return cachedData.map((e) => Country.fromJson(e)).toList();
    }catch (parseError) {
        final box = Hive.box('countries_box');
        await box.clear();
      }}

    final countries = await _repository.fetchAllCountries();

    final rawDataForCache = countries.map((c) => c.toJson()).toList();
    await _cache.saveCountries(rawDataForCache);

    return countries;
  }

}

final countryProvider = AsyncNotifierProvider<CountryNotifier, List<Country>>(CountryNotifier.new);