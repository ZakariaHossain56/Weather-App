class Weather{
  final String cityName;
  final double temperature;
  final String mainCondition;


  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });


//Weather.fromJson is a factory constructor that creates a Weather object from the decoded JSON data.
  factory Weather.fromJson(Map<String,dynamic>json){
    return Weather(
      cityName: json['name'], 
      temperature: json['main']['temp'].toDouble(), 
      mainCondition: json['weather'][0]['main'],
      );
  }



}