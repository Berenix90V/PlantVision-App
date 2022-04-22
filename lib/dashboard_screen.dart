import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  //TODO: fix API of return user data from "Temeperature" to "Temperature"
  final Map<String, dynamic> userData = const {
    "username": "cristian",
    "plants": [
      {
        "type": "Basel",
        "name": "Basel",
        "location": "Kitchen",
        "description": "Basel plant in the kitchen",
        "sensor": [
          {
            "airTemperature": 24.2,
            "airHumidity": 85,
            "soilMoisture": 44.45,
            "lightIntensity": 90
          }
        ]
      },
      {
        "type": "Parsley",
        "name": "Parsley",
        "location": "Kitchen",
        "description": "Parsley plant in the kitchen",
        "sensor": [
          {
            "airTemperature": 24.2,
            "airHumidity": 85,
            "soilMoisture": 44.45,
            "lightIntensity": 90
          }
        ]
      },
      {
        "type": "Parsley",
        "name": "Parsley",
        "location": "LivingRoom",
        "description": "Parsley plant in the kitchen",
        "sensor": [
          {
            "airTemperature": 24.2,
            "airHumidity": 85,
            "soilMoisture": 44.45,
            "lightIntensity": 90
          }
        ]
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    // TODO: implement a class Plant in models
    List<Map<String, dynamic>> plants = userData["plants"];
    return MaterialApp(
      title: 'Your Plants',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Your Plants")
        ),
        // TODO: return them divided by location (different ListView builders)
        body: ListView.builder(
          itemCount: plants.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              // TODO: try with custom icons
              leading: const Icon(Icons.spa),
              title:Text(plants[index]["name"]),
              trailing: Text(plants[index]["location"]),

              //onTap: ()=>PlantDashboardScreen(plant:plants[index]),

            );
          },
        ),
      ),
    );
  }
}
