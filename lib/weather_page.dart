import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

const _apiKey = '2b1e1916f60701eb6a40a96aeaceb284';


// PAGE 2: WEATHER PAGE
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  bool _isLoading = true;
  String cityName = '';
  double temperature = 0;
  String description = '';
  int humidity = 0;


  @override
  void initState () {
    super.initState();
    _loadWeather();
  }

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  Future<Position> getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    print(position);
    return position;
  }

  Future<void> _loadWeather() async{
    try {
      Position position = await getLocation();

      http.Response response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather''?lat=${position.latitude}&lon=${position.longitude}&units=imperial&appid=$_apiKey'));
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        cityName = data['name'];
        temperature = (data['main']['temp'] as num).toDouble();
        description = data['weather'][0]['description'];
        humidity = data['main']['humidity'];

        print('$cityName: $temperature, $description, $humidity%');
      }
    }
    catch (e, stack) {
      print('Error: $e');
      print(stack);
    }
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Current Weather')),
      ),
      body: _isLoading ? SpinKitSpinningLines(
          color: Colors.blue,
          size: 200
      ):



      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wb_cloudy,
              size: 80,
              color: Colors.lightBlue,
            ),
            SizedBox(height: 20,),
            Text(
              cityName,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20,),
            Text(
              '${temperature.round()}°F',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              description,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20,),

            Text('Humidity: $humidity%',),

            SizedBox(height: 20,),

            ElevatedButton(onPressed: ()
            {
              print('back button pressed');
              Navigator.pop(context);
            },
              child: Text('Back to Home'),),


          ],
        ),
      ),

    );
  }
}

