import 'dart:async';
import 'dart:convert';

import 'package:smart_plants_app/models/Plant.dart';

import '../utils/BackendConnection.dart';


/// Defines a plant.
class Hub {

  /// List of Plants
  final List<Plant>? plants;

  /// name of the hub
  final String name;

  /// where is located in the house/building
  final String location;

  /// number of plants per hub
  final int slots;

  /// Constructs a new [Hub].
  Hub(this.name, this.location, this.slots, this.plants);


  /// Returns the JSON representation of this hub
  Map<String, dynamic> get json => {
    "name": name,
    "location": location,
    "slots": slots,
    "free_slots": plants==null? slots: slots - plants!.length,
    "plants" : plants
  };

  static Future<List<Plant?>> hubPlants (String username, String hubname) async {
    return await BackendConnection.getHubPlants(username, hubname).then((response) => (jsonDecode(response.body) as List<dynamic>).map((e)
    {
      return e == null ? null : Plant(e["type"], e["name"], e["description"]);
    }).toList());
  }


  @override
  String toString() {
    return "{" + name + "," + location + "," + slots.toString() + "}";
  }

}