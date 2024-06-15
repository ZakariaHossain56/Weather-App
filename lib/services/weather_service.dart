// helps us fetch the data
import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


import 'package:weather_app/models/weather_model.dart';

class WeatherService{
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

// The http.get function is used to make an HTTP GET request.
// Uri.parse constructs the complete URL by combining the base URL, the city name, your API key, and the units parameter (set to 'metric' for Celsius).
// await pauses the execution of the function until the HTTP request completes and the response is received.
  Future<Weather> getWeather(String cityName) async{
    final response = await http
    .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if(response.statusCode == 200){
      Weather weather = Weather.fromJson(jsonDecode(response.body));
      printWeather(weather);
      return weather;
    }
    else{
      throw Exception('Failed to load weather data');
    }
  }

  void printWeather(Weather weather) {
  print('Cityname: ${weather.cityName}');
  print('Temperature: ${weather.temperature}°C');
  print('Condition: ${weather.mainCondition}');
}

  Future<String>getCurrentCity() async{

    //get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    //fetch the current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );

      //convert the location into a list of placemark objects
      List<Placemark> placemarks = 
        await placemarkFromCoordinates(position.latitude, position.longitude);
        print("Placemarks: ");
        // print(placemarks);

      //extract the city name from the first placemark
      String? city = placemarks[0].subAdministrativeArea;
      // print("City name: ");
      // print(city);

      // Split the input string by spaces
      List<String> words = city?.split(' ') ?? [];
      // Get the first word
      String firstWord = words.isNotEmpty ? words[0] : '';
      print(firstWord);
      city = firstWord;
      return city ?? "";    //if it's null, just return an empty string
  }
}