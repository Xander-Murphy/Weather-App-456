
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const APIkey = '2b1e1916f60701eb6a40a96aeaceb284';

void main() {
  runApp(NetworkingApp(),);
}


class NetworkingApp extends StatelessWidget {
  const NetworkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.low,
    distanceFilter: 100,
  );

  void getLocation() async{
    //Ask for permission
    LocationPermission permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    print(position);
  }

  void getData() async{
    http.Response response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=-84.46&lon=10.99&appid=$APIkey'));
    print(response.statusCode);
    //print(response.body);
    String weather_data = response.body;
    //print(weather_data);

    var longitutde = jsonDecode(weather_data)['coord']['lon'];
    print(longitutde);

    var weatherDescription = jsonDecode(weather_data)['weather'][0]['description'];
    print(weatherDescription);

    var temp = jsonDecode(weather_data)['main']['temp'];
    print(temp);

    var humidity = jsonDecode(weather_data)['main']['humidity'];
    print(humidity);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('New Weather App')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud,
              size: 80,
              color: Colors.blue,
            ),
            SizedBox(height: 30,),
            Text(
              'Welcome to the Weather App',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20,),

            ElevatedButton(
              onPressed: ()
              {
                print('Location button pressed');
                getData();
              }, child: Text('Check Weather'),
            ),
          ],
        ),
      ),
    );
  }
}

