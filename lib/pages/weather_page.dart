import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //api key
  final _weatherService = WeatherService("171b4d7e08982c4c5b8c9574054ab8d1");
  Weather? _weather;

  //fetch weather
  _fetchWeather() async{
    //get the current city
    String cityName = await _weatherService.getCurrentCity();


    print("City name: ");
    print(cityName);

    //manually using cityname
    cityName = 'Joypur Hāt';

    //get weather for this city
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        
      });
    }
    //any errors
    catch(e){
      // ignore: prefer_interpolation_to_compose_strings
      print("Error: " + e.toString());
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition){
    if(mainCondition == null) return 'assets/sunny.json';   //default to sunny

    switch(mainCondition.toLowerCase()){
      case 'clouds':
        return 'assets/cloud.json';
      case 'rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }


  //init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //fetch weather on startup
    _fetchWeather();
    
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(
              _weather?.cityName ?? "loading city..",
              style: TextStyle(
                color: Colors.white, // Change this to the desired color
                fontSize: 32.0,    // Change this to the desired font size
                ),
              ),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            //temperature
            Text(
              '${_weather?.temperature.round()}°C',
              style: TextStyle(
                color: Colors.white, // Change this to the desired color
                fontSize: 64.0,    // Change this to the desired font size
                ),
              ),

            //weather condition
            Text(
              _weather?.mainCondition ?? "",
              style: TextStyle(
                color: Colors.white, // Change this to the desired color
                fontSize: 18.0,    // Change this to the desired font size
                ),
              )
          ],

        ),
      ),
    );
  }
}