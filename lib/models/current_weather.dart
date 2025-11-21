import 'package:weather_application/models/temperature.dart';
import 'package:weather_application/models/weather.dart';

class CurrentWeather extends Weather {
  final String city;
  final String country;

  CurrentWeather({
    required this.city,
    required this.country,
    required super.time,
    required super.temp,
    required super.feelsLike,
    required super.tempMin,
    required super.tempMax,
    required super.humidity,
    required super.main,
    required super.description,
    required super.icon,
    required super.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      city: json["name"],
      country: json["sys"]["country"],
      time: DateTime.fromMillisecondsSinceEpoch(json["dt"] * 1000),
      temp: Temperature(json["main"]["temp"].round()),
      feelsLike: Temperature(json["main"]["feels_like"].round()),
      tempMin: Temperature(json["main"]["temp_min"].round()),
      tempMax: Temperature(json["main"]["temp_max"].round()),
      humidity: json["main"]["humidity"],
      main: json["weather"][0]["main"],
      description: json["weather"][0]["description"],
      icon: json["weather"][0]["icon"],
      windSpeed: json["wind"]["speed"],
    );
  }
}
