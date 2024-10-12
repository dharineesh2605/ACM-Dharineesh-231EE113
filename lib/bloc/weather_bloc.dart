import 'package:bloc/bloc.dart';
import 'package:sample_app/bloc/weather_event.dart';
import 'weather_state.dart';
import 'package:sample_app/worker/worker.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  Worker weather;

  WeatherBloc(this.weather) : super(WeatherInitial()) {
    on<GetWeatherByCityEvent>((event, emit) async {
      emit(WeatherLoading());
      try {
        await weather.getData(event.cityName);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });

    on<GetWeatherEvent>((event, emit) async {
      emit(WeatherLoading());
      try {
        await weather.getDataByLocation(event.latitude, event.longitude);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });


  }
}

