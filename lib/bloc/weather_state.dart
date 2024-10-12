import 'package:equatable/equatable.dart';
import 'package:sample_app/worker/worker.dart';


abstract class WeatherState extends Equatable {
  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  Worker weather;

  WeatherLoaded(this.weather);

  @override
  List<Object> get props => [weather];
}

class WeatherError extends WeatherState {
  String message;

  WeatherError(this.message);

  @override
  List<Object> get props => [message];
}