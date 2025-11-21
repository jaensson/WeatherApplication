import 'package:weather_application/models/temperature.dart';

class Weather {
  final DateTime time;

  final Temperature temp;
  final Temperature feelsLike;
  final Temperature tempMin;
  final Temperature tempMax;
  final num humidity;

  final String main;
  final String description;
  final String icon;

  final num windSpeed;

  Weather({
    required this.time,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.main,
    required this.description,
    required this.icon,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
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
