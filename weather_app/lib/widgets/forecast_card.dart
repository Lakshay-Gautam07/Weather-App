import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather_model.dart';

class ForecastCard extends StatelessWidget {
  final Forecast forecast;
  const ForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
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
              '7-Day Forecast',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: forecast.forecastday.length,
                itemBuilder: (context, index) {
                  return _ForecastItem(day: forecast.forecastday[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForecastItem extends StatelessWidget {
  final ForecastDay day;
  const _ForecastItem({required this.day});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(DateFormat.E().format(DateTime.parse(day.date))),
          const SizedBox(height: 8),
          Image.network('https:${day.day.condition.icon}'),
          const SizedBox(height: 8),
          Text('${day.day.maxtemp_c.toStringAsFixed(0)}°/${day.day.mintemp_c.toStringAsFixed(0)}°'),
        ],
      ),
    );
  }
}
