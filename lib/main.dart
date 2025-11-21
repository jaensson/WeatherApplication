import 'package:weather_application/pages/about.dart';
import 'package:weather_application/pages/current.dart';
import 'package:weather_application/pages/forecast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff458588)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff458588),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _body = const [
    Current(),
    Forecast(),
    About(),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: _appBar(theme),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _body[_currentIndex],
      ),
      bottomNavigationBar: _navigationBar(theme),
    );
  }

  AppBar _appBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.primaryColor,
      centerTitle: true,
      title: const Text("Weather app"),
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    );
  }

  NavigationBar _navigationBar(ThemeData theme) {
    return NavigationBar(
      onDestinationSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      indicatorColor: theme.highlightColor,
      selectedIndex: _currentIndex,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home),
          selectedIcon: Icon(Icons.home_outlined),
          label: "Current",
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart),
          selectedIcon: Icon(Icons.bar_chart_outlined),
          label: "Forecast",
        ),
        NavigationDestination(
          icon: Icon(Icons.info),
          selectedIcon: Icon(Icons.info_outline),
          label: "About",
        ),
      ],
    );
  }
}
