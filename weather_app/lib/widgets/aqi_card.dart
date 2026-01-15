import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';

class AqiCard extends StatelessWidget {
  final AirQuality airQuality;
  const AqiCard({super.key, required this.airQuality});

  @override
  Widget build(BuildContext context) {
    final aqiData = _getAqiData(airQuality.usEpaIndex);

    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Air Quality Index (AQI)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  airQuality.usEpaIndex.toString(),
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text(
                  aqiData['level'],
                  style: TextStyle(fontSize: 18, color: aqiData['color']),
                ),
                const Spacer(),
                Icon(
                  aqiData['icon'],
                  color: aqiData['color'],
                  size: 40,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: airQuality.usEpaIndex / 6,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(aqiData['color']),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getAqiData(int aqi) {
    if (aqi <= 1) {
      return {'level': 'Good', 'color': Colors.green, 'icon': Icons.mood};
    } else if (aqi <= 2) {
      return {
        'level': 'Moderate',
        'color': Colors.yellow,
        'icon': Icons.mood
      };
    } else if (aqi <= 3) {
      return {
        'level': 'Unhealthy for sensitive groups',
        'color': Colors.orange,
        'icon': Icons.mood_bad
      };
    } else if (aqi <= 4) {
      return {
        'level': 'Unhealthy',
        'color': Colors.red,
        'icon': Icons.mood_bad
      };
    } else if (aqi <= 5) {
      return {
        'level': 'Very Unhealthy',
        'color': Colors.purple,
        'icon': Icons.mood_bad
      };
    } else {
      return {
        'level': 'Hazardous',
        'color': Colors.brown,
        'icon': Icons.mood_bad
      };
    }
  }
}
