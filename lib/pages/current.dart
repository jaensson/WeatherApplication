import 'dart:convert';

import 'package:weather_application/models/current_weather.dart';
import 'package:weather_application/models/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Current extends StatefulWidget {
  const Current({super.key});

  @override
  State<Current> createState() => _CurrentState();
}

class _CurrentState extends State<Current> {
  late Future<CurrentWeather> futureCurrentWeather;

  @override
  void initState() {
    super.initState();
    futureCurrentWeather = fetchCurrentWeather();
  }

  Future<CurrentWeather> fetchCurrentWeather() async {
    Position position = await Location.getCurrentPosition();

    String url =
        "${dotenv.env['BASE_API_URL']}/weather?units=metric&lat=${position.latitude}&lon=${position.longitude}&appid=${dotenv.env['APP_ID']}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return CurrentWeather.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Failed to load current weather");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: futureCurrentWeather,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            CurrentWeather currentWeather = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _currentWeather(currentWeather),
            );
          }
          if (snapshot.hasError) {
            return const Text(
              "Something went wrong loading current weather. Please make sure you have allowed permission to location.",
              textAlign: TextAlign.center,
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _currentWeather(CurrentWeather currentWeather) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            _weatherIcon(currentWeather),
            const SizedBox(width: 10),
            _weatherData(currentWeather),
          ],
        ),
      ),
    );
  }

  SizedBox _weatherIcon(CurrentWeather currentWeather) {
    return SizedBox.fromSize(
      size: const Size.fromRadius(64),
      child: Image.network(
        "https://openweathermap.org/img/wn/${currentWeather.icon}@4x.png",
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    );
  }

  Column _weatherData(CurrentWeather currentWeather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${currentWeather.temp}",
          style: const TextStyle(
            fontSize: 32,
          ),
        ),
        Row(
          children: [
            const Icon(
              Icons.location_pin,
              size: 16,
            ),
            Text(
              "${currentWeather.city}, ${currentWeather.country}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
            "${currentWeather.tempMin} / ${currentWeather.tempMax} feels like ${currentWeather.feelsLike}"),
        Text(DateFormat("E, HH:mm").format(currentWeather.time)),
      ],
    );
  }
}
