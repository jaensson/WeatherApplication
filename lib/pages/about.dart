import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Project Weather",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20),
        Text(
          "This is an app developed for a course at university using Flutter and the OpenWeatherMap API.",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Text("Developed by Jaensson"),
      ],
    );
  }
}
