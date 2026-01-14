import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/models/weather_model.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final position = await _locationService.getCurrentPosition();
      final weather = await _weatherService.getWeatherData(
          position.latitude, position.longitude);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Center(
        child: _buildWeatherContent(),
      ),
    );
  }

  Widget _buildWeatherContent() {
    if (_isLoading) {
      return const CircularProgressIndicator();
    } else if (_errorMessage != null) {
      return Text('Error: $_errorMessage');
    } else if (_weather != null) {
      return Container(
        decoration: _getBackgroundDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _weather!.locationName,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              '${_weather!.tempC.toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Image.network('https:${_weather!.iconUrl}'),
            Text(
              _weather!.conditionText,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  _buildDetailItem('Humidity', '${_weather!.humidity}%'),
                  _buildDetailItem('Wind', '${_weather!.windKph} kph'),
                  _buildDetailItem('Sunrise', _weather!.forecast.forecastday[0].astro.sunrise),
                  _buildDetailItem('Sunset', _weather!.forecast.forecastday[0].astro.sunset),
                  _buildDetailItem('AQI', _weather!.airQuality.usEpaIndex.toString()),
                  _buildDetailItem('Feels Like', '${_weather!.feelsLikeC.toStringAsFixed(1)}°C'),
                  _buildDetailItem('UV', _weather!.uv.toString()),
                  _buildDetailItem('Gust', '${_weather!.gustKph} kph'),
                  _buildDetailItem('Cloud', '${_weather!.cloud}%'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '7-Day Forecast',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _weather!.forecast.forecastday.length,
                itemBuilder: (context, index) {
                  final day = _weather!.forecast.forecastday[index];
                  return _buildForecastItem(day);
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return const Text('No weather data to display.');
    }
  }

  Widget _buildForecastItem(ForecastDay day) {
    return ListTile(
      leading: Image.network('https:${day.day.condition.icon}'),
      title: Text(day.date, style: const TextStyle(color: Colors.white)),
      subtitle: Text(day.day.condition.text, style: const TextStyle(color: Colors.white70)),
      trailing: Text(
        '${day.day.maxtemp_c.toStringAsFixed(1)}° / ${day.day.mintemp_c.toStringAsFixed(1)}°',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.white)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  BoxDecoration _getBackgroundDecoration() {
    String condition = _weather?.conditionText.toLowerCase() ?? '';
    String iconUrl = _weather?.iconUrl ?? '';
    bool isDay = iconUrl.contains('day');

    if (condition.contains('sunny')) {
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.yellow, Colors.orange],
        ),
      );
    } else if (condition.contains('cloudy') || condition.contains('overcast')) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blueGrey, Colors.grey.shade700],
        ),
      );
    } else if (condition.contains('rain') || condition.contains('drizzle')) {
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo, Colors.blueGrey],
        ),
      );
    } else if (condition.contains('snow') || condition.contains('sleet') || condition.contains('ice')) {
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.lightBlueAccent, Colors.white],
        ),
      );
    } else if (!isDay) {
       return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.black, Colors.indigo],
        ),
      );
    } else {
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Colors.lightBlueAccent],
        ),
      );
    }
  }
}
