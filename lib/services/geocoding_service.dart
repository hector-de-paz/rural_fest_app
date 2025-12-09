import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GeocodingService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org/search';

  /// Returns [latitude, longitude] or null if not found
  static Future<List<double>?> getCoordinates(String placeName) async {
    try {
      final uri = Uri.parse('$_baseUrl?q=$placeName&format=json&limit=1');
      // Nominatim requires a User-Agent
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'RuralFestApp/1.0'},
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          return [lat, lon];
        }
      }
    } catch (e) {
      debugPrint('Error geocoding: $e');
    }
    return null;
  }
}
