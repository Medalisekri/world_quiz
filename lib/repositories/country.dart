
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class CountryRepository  {
  final Dio _dio = Dio(BaseOptions(
      baseUrl: 'https://api.restcountries.com/countries/v5',
      headers: {
        'Authorization' :'Bearer ${dotenv.env['API_KEY']}',
        'Content-Type':'application/json'
      }
  ));

  Future<List<Map<String, dynamic>>> fetchAllCountries() async {
    try {
      const int limit = 100;
      int offset = 0;
      final List<Map<String , dynamic>> countries = [];
      const excluded = {
        'Northern Cyprus',
        'Abkhazia',
        'Israel',
        'Somaliland',
        'South Ossetia',
      };
      while (true) {
        final response = await _dio.get(
          '',
          queryParameters: {'limit': limit, 'offset': offset},
        );
        final List<dynamic> rawData =
        response.data['data']['objects'] as List<dynamic>;
        rawData.removeWhere(
              (country) => excluded.contains(country['names']['common']),
        );
        countries.addAll(rawData.cast<Map<String , dynamic>>());
        final meta = response.data['data']['meta'];
        final bool hasMore = meta['more'] as bool;
        if (!hasMore) break;
        offset += limit;
      }
      return countries;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Failed to fetch countries',
      );
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }

 }
}