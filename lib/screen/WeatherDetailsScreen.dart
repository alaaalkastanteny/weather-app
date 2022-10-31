import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather2/Screen/Search_screen.dart';
import 'package:weather2/managers/location_managers.dart';
import 'package:weather2/model/LocationPosition.dart';
import '../managers/api_manager.dart';
import '../model/weather_hourly.dart';
import '../model/weather_info.dart';

const ktextcolor = Color.fromARGB(255, 47, 46, 98);
Color bg1 = const Color.fromARGB(255, 74, 133, 233);
Color bg2 = const Color.fromARGB(255, 30, 60, 80);

class WeatherDetailsScreen extends StatefulWidget {
  const WeatherDetailsScreen({Key? key}) : super(key: key);

  @override
  _WeatherDetailsScreenState createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            bg1,
            bg2,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(
            Icons.location_pin,
            color: ktextcolor,
          ),
          title: Text(
            currentWitherInfo.cityname!,
            style: const TextStyle(
              color: ktextcolor,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      isLoding = true;
                      getMyWeather();
                    });
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: ktextcolor,
                  )),
            ),
            Padding(
                padding: const EdgeInsets.all(12),
                child: IconButton(
                  onPressed: () async {
                    String? searchcityName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchScreen()));
                    if (searchcityName != null) {
                      print(searchcityName);
                      getCityWeather(searchcityName);
                    }
                  },
                  icon: const Icon(
                    Icons.location_city,
                    color: ktextcolor,
                  ),
                )),
          ],
        ),
        body: isLoding
            ? const Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    color: ktextcolor,
                  ),
                ),
              )
            : Stack(
                children: [
                  PageView(
                    controller: _controller,
                    onPageChanged: (newpageindex) {
                      setState(() {
                        currentPage = newpageindex;
                        switch (newpageindex) {
                          case 0:
                            bg1 = const Color.fromARGB(255, 74, 133, 233);
                            bg2 = const Color.fromARGB(255, 30, 60, 80);

                            break;
                          case 1:
                            bg1 = const Color.fromARGB(255, 0, 0, 70);
                            bg2 = const Color.fromARGB(255, 50, 60, 100);
                            break;
                          case 2:
                            bg1 = const Color.fromARGB(255, 133, 169, 233);
                            bg2 = const Color.fromARGB(255, 70, 156, 153);
                            break;
                        }
                      });
                    },
                    children: [
                      Column(
                        children: [
                          Lottie.network(
                            'https://assets6.lottiefiles.com/packages/lf20_qqt9hvgz.json',
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.width * 0.7,
                            fit: BoxFit.fill,
                          ),
                          Text(
                            currentWitherInfo.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            currentWitherInfo.temp.toString() + "°",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 85,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.network(
                                'https://assets6.lottiefiles.com/packages/lf20_qdgvz2hn.json',
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: MediaQuery.of(context).size.width * 0.1,
                                fit: BoxFit.fill,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${currentWitherInfo.widSpeed} km/h",
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              const SizedBox(
                                width: 75,
                              ),
                              Lottie.network(
                                'https://assets6.lottiefiles.com/packages/lf20_72kxuu2d.json',
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: MediaQuery.of(context).size.width * 0.1,
                                fit: BoxFit.fill,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${currentWitherInfo.humidity} %",
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.23,
                            child: ListView.builder(
                              itemCount: /*hourlys.length*/ 24,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                DateTime CurrentTime = DateTime.now();
                                CurrentTime =
                                    CurrentTime.add(Duration(hours: index));
                                int h = CurrentTime.hour;
                                return Container(
                                  margin: const EdgeInsets.all(10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  height:
                                      MediaQuery.of(context).size.height * 0.21,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white.withAlpha(50),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        (h % 12).toString() +
                                            ((h >= 12) ? ":00 Pm" : ":00 Am"),
                                      ),
                                      Lottie.network(
                                        'https://assets6.lottiefiles.com/private_files/lf30_jmgekfqg.json',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        fit: BoxFit.fill,
                                      ),
                                      Text(
                                        currentWitherInfo.temp.toString() +
                                            "°" /* hourlys[index].temp*/,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Lottie.network(
                            'https://assets6.lottiefiles.com/packages/lf20_qjq70sp1.json',
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.width * 0.7,
                            fit: BoxFit.fill,
                          ),
                          Text(
                            currentWitherInfo.status,
                            style: const TextStyle(
                              color: Colors.white,
                              letterSpacing: 2,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            currentWitherInfo.temp.toString() + "°",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 85,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.network(
                                'https://assets6.lottiefiles.com/packages/lf20_qdgvz2hn.json',
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: MediaQuery.of(context).size.width * 0.1,
                                fit: BoxFit.fill,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${currentWitherInfo.widSpeed} km/h",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 75,
                              ),
                              Lottie.network(
                                'https://assets6.lottiefiles.com/packages/lf20_72kxuu2d.json',
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: MediaQuery.of(context).size.width * 0.1,
                                fit: BoxFit.fill,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${currentWitherInfo.humidity} %",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.23,
                            child: ListView.builder(
                              itemCount: 24,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                DateTime CurrentTime = DateTime.now();
                                CurrentTime =
                                    CurrentTime.add(Duration(hours: index));
                                int h = CurrentTime.hour;
                                return Container(
                                  margin: const EdgeInsets.all(10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  height:
                                      MediaQuery.of(context).size.height * 0.21,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white.withAlpha(50),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        (h % 12).toString() +
                                            ((h >= 12) ? ":00 Pm" : ":00 Am"),
                                      ),
                                      Lottie.network(
                                        'https://assets6.lottiefiles.com/private_files/lf30_jmgekfqg.json',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        fit: BoxFit.fill,
                                      ),
                                      Text(
                                        currentWitherInfo.temp.toString() + "°",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Lottie.network(
                            'https://assets6.lottiefiles.com/packages/lf20_stwvst8g.json',
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.width * 0.7,
                            fit: BoxFit.fill,
                          ),
                          Text(
                            currentWitherInfo.status,
                            style: const TextStyle(
                              color: ktextcolor,
                              letterSpacing: 2,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            currentWitherInfo.temp.toString() + "°",
                            style: const TextStyle(
                              color: ktextcolor,
                              fontSize: 85,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.network(
                                'https://assets6.lottiefiles.com/packages/lf20_qdgvz2hn.json',
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: MediaQuery.of(context).size.width * 0.1,
                                fit: BoxFit.fill,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${currentWitherInfo.widSpeed} km/h",
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                width: 75,
                              ),
                              Lottie.network(
                                'https://assets6.lottiefiles.com/packages/lf20_72kxuu2d.json',
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: MediaQuery.of(context).size.width * 0.1,
                                fit: BoxFit.fill,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${currentWitherInfo.humidity} %",
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.23,
                            child: ListView.builder(
                              itemCount: 24,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                DateTime CurrentTime = DateTime.now();
                                CurrentTime =
                                    CurrentTime.add(Duration(hours: index));
                                int h = CurrentTime.hour;
                                return Container(
                                  margin: const EdgeInsets.all(10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  height:
                                      MediaQuery.of(context).size.height * 0.21,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white.withAlpha(50),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        (h % 12).toString() +
                                            ((h >= 12) ? ":00 Pm" : ":00 Am"),
                                      ),
                                      Lottie.network(
                                        'https://assets6.lottiefiles.com/private_files/lf30_jmgekfqg.json',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        fit: BoxFit.fill,
                                      ),
                                      Text(
                                        currentWitherInfo.temp.toString() + "°",
                                        style: const TextStyle(
                                          color: ktextcolor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.58,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                            onTap: () {
                              _controller.animateToPage(0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.linear);
                            },
                            child: Text(
                              "Today  ${DateFormat("dd MMM").format(DateTime.now())}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: currentPage == 0
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                wordSpacing: 2,
                                color: currentPage == 0
                                    ? Colors.black87
                                    : Colors.black38,
                              ),
                            )),
                        InkWell(
                            onTap: () {
                              _controller.animateToPage(1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linear);
                            },
                            child: Text(
                              dateFormat.format(tomorrow),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: currentPage == 1
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                wordSpacing: 2,
                                color: currentPage == 1
                                    ? Colors.black87
                                    : Colors.black38,
                              ),
                            )),
                        InkWell(
                            onTap: () {
                              _controller.animateToPage(2,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.linear);
                            },
                            child: Text(
                              dateFormat.format(afterTomorrow),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: currentPage == 2
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                wordSpacing: 2,
                                color: currentPage == 2
                                    ? Colors.black87
                                    : Colors.black38,
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  final PageController _controller = PageController();
  int currentPage = 0;
  bool isLoding = true;
  // String SelectedCity = "Damascus";
  DateFormat dateFormat = DateFormat("E dd MMM");
  DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
  DateTime afterTomorrow = DateTime.now().add(const Duration(days: 2));
  List<WeatherHourly> hourlys = [];

  WeatherInfo currentWitherInfo = WeatherInfo(
    cityname: "",
    humidity: 0,
    status: "",
    temp: 0,
    widSpeed: 0,
    IconId: 0,
  );
  @override
  void initState() {
    super.initState();
    //getMyweatherhourly();
    getMyWeather();
  }

  void getMyWeather() async {
    LocationManager locationManager = LocationManager();
    LocationPosition myLocation = await locationManager.getLocation();
    //print(myLocation.latitude);
    //print(myLocation.longitude);
    String? weatherData = await apiManger.getCurrentWeatherForLocaton(
        myLocation.longitude, myLocation.latitude);
    Map<String, dynamic> data = json.decoder.convert(weatherData!);
    currentWitherInfo = WeatherInfo.fromJsonData(data);
    setState(() {
      isLoding = false;
      // SelectedCity = currentWitherInfo.cityname!;
    });

    /*getMyweatherhourly() async {
      LocationManager locationManager = LocationManager();
      LocationPosition myLocation = await locationManager.getLocation();
      dynamic data = await apiManger.getCurrentWeatherhourly(
          myLocation.longitude, myLocation.latitude);
      hourlys = WeatherHourly.fromJsonArray(data);
    }*/

    /*print(currentWitherInfo.cityname);
    print(currentWitherInfo.temp);
    print(currentWitherInfo.status);
    print(currentWitherInfo.humidity);
    print(currentWitherInfo.widSpeed);
    print(currentWitherInfo.IconId);*/
  }

  void getCityWeather(String cityName) async {
    setState(() {
      isLoding = true;
    });
    LocationManager locationManager = LocationManager();
    LocationPosition myLocation = await locationManager.getLocation();
    //print(myLocation.latitude);
    //print(myLocation.longitude);
    String? weatherData =
        await apiManger.getCurrentWeatherForCityName(cityName);
    Map<String, dynamic> data = json.decoder.convert(weatherData!);
    currentWitherInfo = WeatherInfo.fromJsonData(data);
    setState(() {
      isLoding = false;
      // SelectedCity = currentWitherInfo.cityname!;
    });

    /* void getMyweatherhourly() async {
    LocationManager locationManager = LocationManager();
    LocationPosition myLocation = await locationManager.getLocation();

    dynamic data = await apiManger.getCurrentWeatherhourly(
        myLocation.longitude, myLocation.latitude);
    hourlys = WeatherHourly.fromJsonArray(data);}*/
  }
}

/*  String getIconURL(){
     if (currentWitherInfo.IconId <= 200 ||
                currentWitherInfo.IconId >= 232)
              {
                Lottie.network(
                    'https://assets2.lottiefiles.com/temp/lf20_Kuot2e.json',
                    width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              fit: BoxFit.fill,
              );
                    
                    return Lottie
              }
            else if (currentWitherInfo.IconId <= 300 ||
                currentWitherInfo.IconId >= 321)
              {
                Lottie.network(
                    'https://assets3.lottiefiles.com/packages/lf20_jmBauI.json'),
              }
            else if (currentWitherInfo.IconId <= 500 ||
                currentWitherInfo.IconId >= 531)
              {
                Lottie.network(
                    'https://assets8.lottiefiles.com/temp/lf20_rpC1Rd.json'),
              }
            else if (currentWitherInfo.IconId <= 600 ||
                currentWitherInfo.IconId >= 622)
              {
                Lottie.network(
                    'https://assets8.lottiefiles.com/temp/lf20_WtPCZs.json'),
              }
            else if (currentWitherInfo.IconId <= 701 ||
                currentWitherInfo.IconId >= 781)
              {
                Lottie.network(
                    'https://assets2.lottiefiles.com/private_files/lf30_jmgekfqg.json'),
              }
            else if (currentWitherInfo.IconId == 800)
              {
                Lottie.network(
                    'https://assets2.lottiefiles.com/packages/lf20_xlky4kvh.json'),
              }
            else
              {
                Lottie.network(
                    'https://assets7.lottiefiles.com/packages/lf20_qqt9hvgz.json'),
              }
  }*/
  

