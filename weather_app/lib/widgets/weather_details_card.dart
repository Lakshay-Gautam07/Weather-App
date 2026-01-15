import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/widgets/detail_item.dart';

class WeatherDetailsCard extends StatelessWidget {
  final Weather weather;
  const WeatherDetailsCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            DetailItem(
              icon: Icons.water_drop,
              label: 'Humidity',
              value: '${weather.humidity}%',
            ),
            DetailItem(
              icon: Icons.air,
              label: 'Wind Speed',
              value: '${weather.windKph.toStringAsFixed(1)} km/h',
            ),
            DetailItem(
              icon: Icons.wb_sunny_outlined,
              label: 'Sunrise',
              value: weather.forecast.forecastday[0].astro.sunrise,
            ),
            DetailItem(
              icon: Icons.wb_twilight_outlined,
              label: 'Sunset',
              value: weather.forecast.forecastday[0].astro.sunset,
            ),
            DetailItem(
              icon: Icons.thermostat,
              label: 'Feels Like',
              value: '${weather.feelsLikeC.toStringAsFixed(1)}°C',
            ),
            DetailItem(
              icon: Icons.wb_iridescent,
              label: 'UV Index',
              value: weather.uv.toString(),
            ),
            DetailItem(
              icon: Icons.speed,
              label: 'Wind Gust',
              value: '${weather.gustKph.toStringAsFixed(1)} km/h',
            ),
            DetailItem(
              icon: Icons.cloud,
              label: 'Cloud %',
              value: '${weather.cloud}%',
            ),
          ],
        ),
      ),
    );
  }
}
