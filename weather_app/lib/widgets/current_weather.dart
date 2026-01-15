import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';

class CurrentWeather extends StatelessWidget {
  final Weather weather;
  const CurrentWeather({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            weather.locationName,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${weather.tempC.toStringAsFixed(1)}°C',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network('https:${weather.iconUrl}'),
              const SizedBox(width: 8),
              Text(weather.conditionText, style: const TextStyle(fontSize: 24)),
            ],
          ),
        ],
      ),
    );
  }
}
