
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_app/worker/worker.dart';
import 'package:sample_app/bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}




class _HomeState extends State<Home> {
  TextEditingController searcher = TextEditingController();



  Future<Position?> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        print('Location permissions are denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }


  void fetchData(String cityName) {
    context.read<WeatherBloc>().add(GetWeatherByCityEvent(cityName));
  }


  void fetchDataByLocation() async {
    try {
      Position? position = await _determinePosition();
      if (position != null) {
        double latitude = position.latitude;
        double longitude = position.longitude;
        print("Current Position: $latitude, $longitude");


        context.read<WeatherBloc>().add(GetWeatherEvent(latitude, longitude));
      } else {
        print("Failed to fetch location.");
      }
    } catch (e) {
      print("Error determining position: $e");
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        centerTitle: true,
        title: Text("Weather"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return buildLoadingUI();
          } else if (state is WeatherLoaded) {
            return buildWeatherDataUI(state.weather);
          } else if (state is WeatherError) {
            return buildErrorUI(state.message, searcher.text);
          } else {
            return buildInitialUI();
          }
        },
      ),
    );
  }


  Widget buildInitialUI() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          height: 1000,
          color: Colors.lightBlueAccent.withOpacity(0.3),
          child: Column(
            children: [
              buildSearchBar(),

              buildWelcomeMessage(),
              SizedBox(height: 40,),

              Text("OR",style: TextStyle(fontSize: 30),),
              SizedBox(height: 40,),
              ElevatedButton(
                onPressed: fetchDataByLocation,
                child: Text("Check for current location"),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white.withOpacity(0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                fetchData(searcher.text);
              },
              child: Icon(Icons.search, size: 30),
            ),
            Expanded(
              child: TextField(
                controller: searcher,
                onEditingComplete: () {
                  fetchData(searcher.text);
                },

                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "search here",
                  hintStyle: TextStyle(color: Colors.black87.withOpacity(0.6)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildWelcomeMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 150),
      child: Column(
        children: [
          Text("Welcome to weather app", style: TextStyle(fontSize: 30)),
          SizedBox(height: 10),
          Text("Please Enter city", style: TextStyle(fontSize: 30)),
        ],
      ),
    );
  }


  Widget buildLoadingUI() {
    return Center(child: CircularProgressIndicator());
  }


  Widget buildWeatherDataUI(Worker weather) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          color: Colors.lightBlueAccent.withOpacity(0.3),
          child: Column(
            children: [
              buildSearchBar(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.4)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 140),
                        child: Text(
                          weather.description,
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.4)),
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[Padding(
                          padding: const EdgeInsets.only(left:160),
                          child: Text("Temperature"),
                        )],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 140, top: 50),
                            child: Text(
                              "${weather.temp} °C",
                              style: TextStyle(fontSize: 40),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  buildWeatherInfoCard(weather.humidity+"%", "Humidity"),
                  buildWeatherInfoCard(weather.windspeed+"km/h", "Wind Speed"),
                ],
              ),
              SizedBox(height: 500),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildWeatherInfoCard(String value, String title) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        width: 180,
        height: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.4)),
          child: Column(

            children: [
              Text(title, textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
              SizedBox(height: 90,),
              Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 10),

            ],
          ),
        ),
    );
  }


  Widget buildErrorUI(String message, String hint) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          color: Colors.lightBlueAccent.withOpacity(0.3),
          child: Column(
            children: [
              buildSearchBar(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(message, style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: fetchDataByLocation, // Try again to fetch location
                child: Text("Check for current location"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
