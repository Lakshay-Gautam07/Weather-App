import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  final String _apiKey = dotenv.env['API_KEY']!;
  final String _baseUrl = 'http://api.weatherapi.com/v1';

  Future<Weather> getWeatherData(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/forecast.json?key=$_apiKey&q=$lat,$lon&days=7&aqi=yes&alerts=yes'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
