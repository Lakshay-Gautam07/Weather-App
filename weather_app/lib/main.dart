import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/aqi_card.dart';
import 'package:weather_app/widgets/custom_search_bar.dart';
import 'package:weather_app/widgets/current_weather.dart';
import 'package:weather_app/widgets/forecast_card.dart';
import 'package:weather_app/widgets/weather_details_card.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        cardColor: Colors.white,
        scaffoldBackgroundColor: Colors.grey.shade100,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
          bodySmall: TextStyle(color: Colors.black54),
          titleLarge: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        cardColor: Colors.grey.shade900,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white70),
          bodySmall: TextStyle(color: Colors.white54),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white70),
        ),
      ),
      themeMode: ThemeMode.system,
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
  String? _currentLocation;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather([String? city]) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      if (city != null && city.isNotEmpty) {
        _weather = await _weatherService.getWeatherDataByCity(city);
      } else {
        final position = await _locationService.getCurrentPosition();
        _weather = await _weatherService.getWeatherData(
            position.latitude, position.longitude);
      }
      setState(() {
        _isLoading = false;
        _currentLocation = _weather?.locationName;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showCitySearch(BuildContext context) async {
    final String? selectedCity = await showSearch<String>(
      context: context,
      delegate: CitySearchDelegate(_weatherService),
    );

    if (selectedCity != null && selectedCity.isNotEmpty) {
      _fetchWeather(selectedCity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildWeatherContent(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _fetchWeather(),
        child: const Icon(Icons.location_on),
      ),
    );
  }

  Widget _buildWeatherContent(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_errorMessage'),
            ElevatedButton(
              onPressed: () => _fetchWeather(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (_weather != null) {
      return Container(
        decoration: _getBackgroundDecoration(),
        child: RefreshIndicator(
          onRefresh: _fetchWeather,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                CustomSearchBar(
                  onTap: () => _showCitySearch(context),
                ),
                CurrentWeather(weather: _weather!),
                ForecastCard(forecast: _weather!.forecast),
                WeatherDetailsCard(weather: _weather!),
                AqiCard(airQuality: _weather!.airQuality),
              ],
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No weather data to display.'),
            ElevatedButton(
              onPressed: () => _showCitySearch(context),
              child: const Text('Search for a city'),
            ),
          ],
        ),
      );
    }
  }

  BoxDecoration _getBackgroundDecoration() {
    String condition = _weather?.conditionText.toLowerCase() ?? '';
    String iconUrl = _weather?.iconUrl ?? '';
    bool isDay = iconUrl.contains('day');

    // Default to a general sky blue if condition is not matched
    List<Color> colors = [Colors.blue, Colors.lightBlueAccent];

    if (condition.contains('sunny') || condition.contains('clear')) {
      colors = [const Color(0xFF47BFDF), const Color(0xFF4A91FF)]; // Sunny/Clear day colors
    } else if (condition.contains('cloudy') || condition.contains('overcast')) {
      colors = [Colors.blueGrey.shade700, Colors.grey.shade800]; // Cloudy day colors
    } else if (condition.contains('rain') || condition.contains('drizzle')) {
      colors = [Colors.indigo.shade700, Colors.blueGrey.shade900]; // Rainy day colors
    } else if (condition.contains('snow') || condition.contains('sleet') || condition.contains('ice')) {
      colors = [Colors.lightBlueAccent.shade100, Colors.white70]; // Snowy day colors
    } else if (!isDay) {
      colors = [Colors.black, Colors.indigo.shade900]; // Night colors
    }

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ),
    );
  }
}

class CitySearchDelegate extends SearchDelegate<String> {
  final WeatherService _weatherService;
  CitySearchDelegate(this._weatherService);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    close(context, query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Start typing to search for cities'));
    }

    return FutureBuilder<List<dynamic>>(
      future: _weatherService.searchCity(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No cities found'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final city = snapshot.data![index];
              return ListTile(
                title: Text(city['name']),
                subtitle: Text('${city['region']}, ${city['country']}'),
                onTap: () {
                  close(context, city['name']);
                },
              );
            },
          );
        }
      },
    );
  }
}
