

import "package:weather/weather.dart";
import "package:location/location.dart";
// import "package:http/http.dart" as http;
// import 'dart:convert';

class WeatherManager {
  String api;  
  late String currWeather = "?";
  WeatherManager(this.api);

  //get location to determine weather from (heavily imported from lab8)
  // Future<(bool enabled, bool hasPermission, (double, double) latLon)>
  //     getCurrentLocation() async {
  //   Location _location = Location();
  //   (double,double) empty = (0,0);
  //   var _enabled = await _location.serviceEnabled();
  //   if (!_enabled) {
  //     _enabled = await _location.requestService();
  //     if (!_enabled) {
  //       return (false, false, empty);
  //     }
  //   }
  //   var _hasPermission = await _location.hasPermission();
  //   if (_hasPermission == PermissionStatus.denied) {
  //     _hasPermission = await _location.hasPermission();
  //     if (_hasPermission == PermissionStatus.denied) {
  //       return (_enabled, false, empty);
  //     }
  //   }
  //   final currentLocation = await _location.getLocation();

  //   //final response = await http.get(Uri.parse(
  //     // "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${currentLocation.latitude}&lon=${currentLocation.longitude}}"));

  //   //final json = jsonDecode(response.body) as Map<String, dynamic>;

  //   return (true, true, (currentLocation.latitude!, currentLocation.longitude!));
  // }



  Future<String> getWeather() async {
    // final record = await getCurrentLocation();

    // if (!record.$1 || !record.$2){
    //   return "Error: Location not available";
    // }

    // var loc = record.$3;

    final location = Location();

    final currentLocation = await location.getLocation();

    final lat = currentLocation.latitude!;
    final lon = currentLocation.longitude!;

    WeatherFactory wf = WeatherFactory(api);

    try {
      Weather weather = await wf.currentWeatherByLocation(lat, lon);
      currWeather = weather.weatherMain ?? "Weather unavailable";
    } catch (e) {
      print(e);
      currWeather = "Error in catching weather...";
    }
    return currWeather;
  }
}

