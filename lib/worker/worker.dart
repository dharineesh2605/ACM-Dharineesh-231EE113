import 'package:http/http.dart';
import 'dart:convert';

class Worker {
  String location = "";
  double latitude = 0;
  double longitude = 0;

  String temp = "";
  String humidity = "";
  String windspeed = "";
  String description = "";
  String feels_like = "";

  Future<void> getData(String location) async {
    Response response = await get(
      Uri.parse(
          "http://api.openweathermap.org/data/2.5/weather?q=$location&appid=cc57849aea1cfb2cfd4434219558b9b6"),
    );
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      List weatherData = data["weather"];
      Map weatherDataMain = weatherData[0];
      Map weatherTempData = data["main"];
      Map windSpeed = data["wind"];

      temp = (weatherTempData["temp"] - 273.15).toStringAsFixed(2);
      feels_like = (weatherTempData["feels_like"] - 273.15).toStringAsFixed(2);
      windspeed = (windSpeed["speed"]).toString();
      humidity = (weatherTempData["humidity"]).toString();
      description = weatherDataMain["description"];
    }
    else {
      temp = "N/A";
      humidity = "N/A";
      windspeed = "N/A";
      description = "Location not found";
      feels_like = "N/A";
    }

  }


  Future<void> getDataByLocation(double lat, double lon) async {
    this.latitude = lat;
    this.longitude = lon;

    Response response = await get(
      Uri.parse(
          "http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=cc57849aea1cfb2cfd4434219558b9b6"),
    );
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      List weatherData = data["weather"];
      Map weatherDataMain = weatherData[0];
      Map weatherTempData = data["main"];
      Map windSpeed = data["wind"];

      temp = (weatherTempData["temp"] - 273.15).toStringAsFixed(2);
      feels_like = (weatherTempData["feels_like"] - 273.15).toStringAsFixed(2);
      windspeed = (windSpeed["speed"]).toString();
      humidity = (weatherTempData["humidity"]).toString();
      description = weatherDataMain["description"];
    }
    else {
      temp = "N/A";
      humidity = "N/A";
      windspeed = "N/A";
      description = "Location not found";
      feels_like = "N/A";
    }

  }
}