// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;

const kServerUrl = "http://api.openweathermap.org/data/2.5";
const kCurrentWeatherApi = "/weather?";

const kRestCountriesURL = "https://restcountries.com/v3.1/all";

class apiManger {
  static Future<String?> getCurrentWeatherForLocaton(
      double lon, double lat) async {
    http.Response response = await http.get(Uri.parse(kServerUrl +
        kCurrentWeatherApi +
        "lat=$lat&lon=$lon&appid=8f5824fa3483104865929814cb07ac46&units=metric"));
    if (response.statusCode ~/ 100 == 2) {
      return response.body;
    } else {
      // ignore: avoid_print
      print(response.statusCode);
      print(response.body);
      return null;
    }
  }

  static Future<String?> getCurrentWeatherhourly(double lon, double lat) async {
    http.Response response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&&appid=8f5824fa3483104865929814cb07ac46&units=metric"));
    if (response.statusCode ~/ 100 == 2) {
      return response.body;
    } else {
      print(response.statusCode);
      print(response.body);
      return null;
    }
  }

  static Future<String?> getCountries() async {
    http.Response response = await http.get(Uri.parse(kRestCountriesURL));
    if (response.statusCode ~/ 100 == 2) {
      return response.body;
    } else {
      print(response.statusCode);
      print(response.body);
      return null;
    }
  }

  static Future<String?> getCurrentWeatherForCityName(String cityName) async {
    http.Response response = await http.get(Uri.parse(kServerUrl +
        kCurrentWeatherApi +
        "q=$cityName&appid=8f5824fa3483104865929814cb07ac46&units=metric"));
    if (response.statusCode ~/ 100 == 2) {
      return response.body;
    } else {
      print(response.statusCode);
      print(response.body);
      return null;
    }
  }
}
