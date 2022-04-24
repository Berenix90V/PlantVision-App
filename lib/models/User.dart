import 'dart:async';
import 'dart:convert';

import 'package:smart_plants_app/models/Hub.dart';
import 'package:smart_plants_app/models/Plant.dart';
import 'package:smart_plants_app/models/SensorReading.dart';
import 'package:smart_plants_app/utils/BackendConnection.dart';


/// Defines a plant.
class User {

  /// List of Plants
  final List<Hub>? hubs;

  /// name of the hub
  final String username;

  /// where is located in the house/building
  final String password;


  /// Constructs a new [User].
  User(this.password, this.hubs, this.username);


  /// Returns the JSON representation of this hub
  Map<String, dynamic> get json =>
      {
        "name": username,
        "hubs": hubs,
      };

  static Future<List<Hub>> userHubs (String username) async {
    return await BackendConnection.getUserHubs(username).then((response) => (jsonDecode(response.body) as List<dynamic>).map((e)
    {
      List<Plant> myplants = (e["plants"] as List<dynamic>).map((p)
      {
        List<SensorReading>? sensorReadings = (p["sensor"] as List<dynamic>).map((sr) => SensorReading(airTemperature: sr["airTemperature"] * 1.0, airHumidity: sr["airHumidity"] * 1.0,
            soilMoisture: sr["soilMoisture"] * 1.0, lightIntensity: sr["lightIntensity"] * 1.0)).toList();
        return Plant(p["plantType"], p["name"], p["description"] ?? "", sensorReadings: sensorReadings);
      }).toList();

      final hub = Hub(e["hub_name"], e["location"], e["slots"], myplants);
      print(hub);
      return hub;
    }).toList());
  }
}
