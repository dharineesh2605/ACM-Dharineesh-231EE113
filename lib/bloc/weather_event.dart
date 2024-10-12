import 'package:equatable/equatable.dart';


abstract class WeatherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetWeatherEvent extends WeatherEvent {
   double latitude;
   double longitude;

  GetWeatherEvent(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];


}

class GetWeatherByCityEvent extends WeatherEvent {
  String cityName;

  GetWeatherByCityEvent(this.cityName);

  @override
  List<Object> get props => [cityName];
}