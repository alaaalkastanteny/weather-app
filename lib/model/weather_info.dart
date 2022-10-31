import 'dart:convert';

class WeatherInfo {
  String? cityname;
  dynamic temp;
  String status;
  int IconId;
  dynamic humidity;
  dynamic widSpeed;
  WeatherInfo({
    required this.cityname,
    required this.humidity,
    required this.status,
    required this.temp,
    required this.widSpeed,
    required this.IconId,
  });

  factory WeatherInfo.fromJsonData(Map<String, dynamic> data) {
    return WeatherInfo(
        cityname: data["name"],
        humidity: data["main"]["humidity"],
        status: data["weather"][0]["main"],
        temp: data["main"]["temp"],
        widSpeed: data["wind"]["speed"],
        IconId: data["weather"][0]["id"]);
  }
}
