class Country {
  final String name;
  final String continent;
  final String capital;
  final int population;
  final String flagUrl;
  final List<String> currencies;
  final List<String> languages;
  final double lat;
  final double lng;

  const Country({
    required this.name,
    required this.continent,
    required this.capital,
    required this.population,
    required this.flagUrl,
    required this.currencies,
    required this.languages,
    required this.lat,
    required this.lng,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    final continents = (json['continents'] as List?) ?? [];
    final capitals = (json['capitals'] as List?) ?? [];
    List<String> currencyList = [];
    List<String> languagesList = [];
    if (json['currencies'] is List) {
      currencyList = (json['currencies'] as List).map((c) {
        if (c is Map) return c['name']?.toString() ?? 'Unknown';
        return c.toString();
      }).toList();
    }
    if (json['languages'] is List) {
      languagesList = (json['languages'] as List).map((l) {
        if (l is Map) return l['name']?.toString() ?? 'Unknown';
        return l.toString();
      }).toList();
    }
    double parsedLat = 0.0;
    double parsedLng = 0.0;

    if (json.containsKey('lat') && json.containsKey('lng')) {
      parsedLat = (json['lat'] as num).toDouble();
      parsedLng = (json['lng'] as num).toDouble();
    }
    else if (json.containsKey('coordinates')) {
      final coords = json['coordinates'];
        parsedLat = ((coords['lat'] ?? coords['latitude'] ?? 0.0) as num).toDouble();
        parsedLng = ((coords['lng'] ?? coords['longitude'] ?? 0.0) as num).toDouble();

    }

    return Country(
      name: json['names']?['common'] ?? 'Unknown',
      continent: continents.isNotEmpty ? continents.first : '',
      capital: capitals.isNotEmpty ? capitals.first['name'] ?? '' : '',
      population: json['population'] ?? 0,
      flagUrl: json['flag']?['url_png'] ?? '',
      currencies: currencyList,
      languages: languagesList,
      lat: parsedLat,
      lng: parsedLng,
    );
  }

}