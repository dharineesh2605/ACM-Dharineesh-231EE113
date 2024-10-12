import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_app/bloc/weather_bloc.dart';
import 'package:sample_app/activity/home.dart';
import 'package:sample_app/activity/loading.dart';
import 'package:sample_app/worker/worker.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});


  @override
  Widget build(BuildContext context) {
    Worker worker = Worker();

    return BlocProvider(
      create: (context) => WeatherBloc(worker),
      child: MaterialApp(
        initialRoute: '/loading',
        routes: {
          '/loading': (context) => LoadingScreen(),
          '/home': (context) => Home(),
        },
      ),
    );
  }
}



