import 'dart:convert';

class WeatherHourly {
  dynamic temp;
  WeatherHourly({this.temp});

  factory WeatherHourly.fromJson(map) => WeatherHourly(
        temp: map["temp"],
      );
  static List<WeatherHourly> fromJsonArray(data) {
    List<WeatherHourly> hourly = [];
    List<dynamic> list = json.decoder.convert(data);
    for (dynamic map in list) {
      hourly.add(WeatherHourly.fromJson(map));
    }
    return hourly;
  }
}
