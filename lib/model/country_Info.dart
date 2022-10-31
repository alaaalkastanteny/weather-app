import 'dart:convert';

class CountryInfo {
  String? name;
  String? capital;
  String? flagUrl;
  CountryInfo({this.capital, this.flagUrl, this.name});

  factory CountryInfo.fromJson(map) => CountryInfo(
        name: map["name"]["official"],
        capital: map["capital"] == null ? "" : map["capital"][0],
        flagUrl: map["flags"]["png"],
      );

  static List<CountryInfo> fromJsonArray(data) {
    List<CountryInfo> countries = [];
    List<dynamic> list = json.decoder.convert(data);
    for (dynamic map in list) {
      countries.add(CountryInfo.fromJson(map));
    }
    return countries;
  }
}
