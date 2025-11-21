import 'dart:convert';

import 'package:weather_application/models/daily_weather.dart';
import 'package:weather_application/models/location.dart';
import 'package:weather_application/models/weather.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Forecast extends StatefulWidget {
  const Forecast({super.key});

  @override
  State<Forecast> createState() => _ForecastState();
}

class _ForecastState extends State<Forecast> {
  late Future<List<DailyWeather>> futureDailyWeathers;

  @override
  void initState() {
    super.initState();
    futureDailyWeathers = fetchIncomingWeather();
  }

  Future<List<DailyWeather>> fetchIncomingWeather() async {
    Position position = await Location.getCurrentPosition();

    String url =
        "${dotenv.env['BASE_API_URL']}/forecast?units=metric&lat=${position.latitude}&lon=${position.longitude}&appid=${dotenv.env['APP_ID']}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<DailyWeather> dailyWeathers = [];
      DailyWeather? currentDailyWeather;

      var incomingWeatherDecoded = jsonDecode(response.body)["list"];
      for (Map<String, dynamic> incomingWeather in incomingWeatherDecoded) {
        Weather weather = Weather.fromJson(incomingWeather);
        currentDailyWeather = currentDailyWeather ?? DailyWeather(weather.time);

        if (currentDailyWeather.date.day != weather.time.day) {
          dailyWeathers.add(currentDailyWeather);
          currentDailyWeather = DailyWeather(weather.time);
        }

        currentDailyWeather.weathers.add(weather);
      }

      return dailyWeathers;
    } else {
      throw Exception("Could not load incoming weather");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: futureDailyWeathers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DailyWeather> dailyWeathers = snapshot.data!;
            return _forecast(dailyWeathers);
          }
          if (snapshot.hasError) {
            return const Text(
              "Something went wrong loading weather. Please make sure you have allowed permission to location.",
              textAlign: TextAlign.center,
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  ListView _forecast(List<DailyWeather> dailyWeathers) {
    return ListView.separated(
      itemCount: dailyWeathers.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 20);
      },
      itemBuilder: (context, index) {
        DailyWeather dailyWeather = dailyWeathers[index];
        return _dailyWeatherCard(dailyWeather);
      },
    );
  }

  Card _dailyWeatherCard(DailyWeather dailyWeather) {
    List<Weather> weathers = dailyWeather.weathers;

    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dailyWeatherCardTitle(dailyWeather),
            const SizedBox(height: 12),
            _dailyWeatherCardBody(weathers),
          ],
        ),
      ),
    );
  }

  Center _dailyWeatherCardTitle(DailyWeather dailyWeather) {
    return Center(
      child: Text(
        DateFormat("MMMMEEEEd").format(dailyWeather.date),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  SizedBox _dailyWeatherCardBody(List<Weather> weathers) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: weathers.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 20);
        },
        itemBuilder: (context, index) {
          Weather weather = weathers[index];
          return _weatherColumn(weather);
        },
      ),
    );
  }

  Column _weatherColumn(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat("Hm").format(weather.time),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox.fromSize(
          size: const Size.fromRadius(24),
          child: Image.network(
            "https://openweathermap.org/img/wn/${weather.icon}.png",
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        Text(
          "${weather.temp}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Icon(
              Icons.water_drop,
              color: Colors.blue.withOpacity(0.7),
            ),
            Text("${weather.humidity}%"),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.air),
            Text("${weather.windSpeed} m/s"),
          ],
        ),
      ],
    );
  }
}
