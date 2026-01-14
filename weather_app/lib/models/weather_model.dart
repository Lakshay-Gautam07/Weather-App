class Weather {
  final String locationName;
  final double tempC;
  final String conditionText;
  final String iconUrl;
  final double windKph;
  final int humidity;
  final int cloud;
  final double feelsLikeC;
  final double uv;
  final double gustKph;
  final AirQuality airQuality;
  final Forecast forecast;

  Weather({
    required this.locationName,
    required this.tempC,
    required this.conditionText,
    required this.iconUrl,
    required this.windKph,
    required this.humidity,
    required this.cloud,
    required this.feelsLikeC,
    required this.uv,
    required this.gustKph,
    required this.airQuality,
    required this.forecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      locationName: json['location']['name'],
      tempC: (json['current']['temp_c'] as num).toDouble(),
      conditionText: json['current']['condition']['text'],
      iconUrl: json['current']['condition']['icon'],
      windKph: (json['current']['wind_kph'] as num).toDouble(),
      humidity: json['current']['humidity'],
      cloud: json['current']['cloud'],
      feelsLikeC: (json['current']['feelslike_c'] as num).toDouble(),
      uv: (json['current']['uv'] as num).toDouble(),
      gustKph: (json['current']['gust_kph'] as num).toDouble(),
      airQuality: AirQuality.fromJson(json['current']['air_quality']),
      forecast: Forecast.fromJson(json['forecast']),
    );
  }
}

class AirQuality {
  final double co;
  final double no2;
  final double o3;
  final double so2;
  final double pm2_5;
  final double pm10;
  final int usEpaIndex;

  AirQuality({
    required this.co,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
    required this.usEpaIndex,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
      co: (json['co'] as num).toDouble(),
      no2: (json['no2'] as num).toDouble(),
      o3: (json['o3'] as num).toDouble(),
      so2: (json['so2'] as num).toDouble(),
      pm2_5: (json['pm2_5'] as num).toDouble(),
      pm10: (json['pm10'] as num).toDouble(),
      usEpaIndex: json['us-epa-index'],
    );
  }
}

class Forecast {
  final List<ForecastDay> forecastday;

  Forecast({required this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    var list = json['forecastday'] as List;
    List<ForecastDay> forecastdayList =
        list.map((i) => ForecastDay.fromJson(i)).toList();
    return Forecast(forecastday: forecastdayList);
  }
}

class ForecastDay {
  final String date;
  final Day day;
  final Astro astro;
  final List<Hour> hour;

  ForecastDay({
    required this.date,
    required this.day,
    required this.astro,
    required this.hour,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    var hourList = json['hour'] as List;
    List<Hour> hours = hourList.map((i) => Hour.fromJson(i)).toList();
    return ForecastDay(
      date: json['date'],
      day: Day.fromJson(json['day']),
      astro: Astro.fromJson(json['astro']),
      hour: hours,
    );
  }
}

class Day {
  final double maxtemp_c;
  final double mintemp_c;
  final double avgtemp_c;
  final double maxwind_kph;
  final double totalprecip_mm;
  final double totalsnow_cm;
  final double avgvis_km;
  final int avghumidity;
  final int daily_will_it_rain;
  final int daily_chance_of_rain;
  final int daily_will_it_snow;
  final int daily_chance_of_snow;
  final Condition condition;
  final double uv;

  Day({
    required this.maxtemp_c,
    required this.mintemp_c,
    required this.avgtemp_c,
    required this.maxwind_kph,
    required this.totalprecip_mm,
    required this.totalsnow_cm,
    required this.avgvis_km,
    required this.avghumidity,
    required this.daily_will_it_rain,
    required this.daily_chance_of_rain,
    required this.daily_will_it_snow,
    required this.daily_chance_of_snow,
    required this.condition,
    required this.uv,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxtemp_c: (json['maxtemp_c'] as num).toDouble(),
      mintemp_c: (json['mintemp_c'] as num).toDouble(),
      avgtemp_c: (json['avgtemp_c'] as num).toDouble(),
      maxwind_kph: (json['maxwind_kph'] as num).toDouble(),
      totalprecip_mm: (json['totalprecip_mm'] as num).toDouble(),
      totalsnow_cm: (json['totalsnow_cm'] as num).toDouble(),
      avgvis_km: (json['avgvis_km'] as num).toDouble(),
      avghumidity: json['avghumidity'],
      daily_will_it_rain: json['daily_will_it_rain'],
      daily_chance_of_rain: json['daily_chance_of_rain'],
      daily_will_it_snow: json['daily_will_it_snow'],
      daily_chance_of_snow: json['daily_chance_of_snow'],
      condition: Condition.fromJson(json['condition']),
      uv: (json['uv'] as num).toDouble(),
    );
  }
}

class Astro {
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;
  final String moon_phase;
  final String moon_illumination;
  final int is_moon_up;
  final int is_sun_up;

  Astro({
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moon_phase,
    required this.moon_illumination,
    required this.is_moon_up,
    required this.is_sun_up,
  });

  factory Astro.fromJson(Map<String, dynamic> json) {
    return Astro(
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      moonrise: json['moonrise'],
      moonset: json['moonset'],
      moon_phase: json['moon_phase'],
      moon_illumination: json['moon_illumination'].toString(),
      is_moon_up: json['is_moon_up'],
      is_sun_up: json['is_sun_up'],
    );
  }
}

class Hour {
  final String time;
  final double temp_c;
  final Condition condition;
  final double wind_kph;
  final int humidity;
  final int cloud;
  final double feelslike_c;
  final int will_it_rain;
  final int chance_of_rain;
  final int will_it_snow;
  final int chance_of_snow;

  Hour({
    required this.time,
    required this.temp_c,
    required this.condition,
    required this.wind_kph,
    required this.humidity,
    required this.cloud,
    required this.feelslike_c,
    required this.will_it_rain,
    required this.chance_of_rain,
    required this.will_it_snow,
    required this.chance_of_snow,
  });

  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(
      time: json['time'],
      temp_c: (json['temp_c'] as num).toDouble(),
      condition: Condition.fromJson(json['condition']),
      wind_kph: (json['wind_kph'] as num).toDouble(),
      humidity: json['humidity'],
      cloud: json['cloud'],
      feelslike_c: (json['feelslike_c'] as num).toDouble(),
      will_it_rain: json['will_it_rain'],
      chance_of_rain: json['chance_of_rain'],
      will_it_snow: json['will_it_snow'],
      chance_of_snow: json['chance_of_snow'],
    );
  }
}

class Condition {
  final String text;
  final String icon;
  final int code;

  Condition({required this.text, required this.icon, required this.code});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'],
      icon: json['icon'],
      code: json['code'],
    );
  }
}
