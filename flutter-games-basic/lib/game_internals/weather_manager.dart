import "package:weather/weather.dart";
import "package:location/location.dart";

class WeatherManager {
  String api;  
  late String currWeather = "?";
  WeatherManager(this.api);

  Future<String> getWeather() async {

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
      currWeather = "Weather unavailable";
    }
    return currWeather;
  }
}

