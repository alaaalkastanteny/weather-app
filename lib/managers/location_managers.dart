import 'package:geolocator/geolocator.dart';

import '../model/LocationPosition.dart';

class LocationManager {
  Future<LocationPosition> _getMyLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    /*print(position.longitude);
    print(position.latitude);*/
    return LocationPosition(position.longitude, position.latitude);
  }

  Future<LocationPosition> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if ((await Geolocator.requestPermission()) ==
          LocationPermission.whileInUse) {
        return await _getMyLocation();
      }
      return LocationPosition(0, 0);
    } else {
      return await _getMyLocation();
    }
  }
}
