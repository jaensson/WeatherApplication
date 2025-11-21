import 'package:weather_application/models/weather.dart';

class DailyWeather {
  final DateTime date;
  List<Weather> weathers = [];

  DailyWeather(this.date);
}
