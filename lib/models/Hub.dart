import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
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
    // TODO togliere questo campo e ctrl che non esploda tutto
    "free_slots": plants==null? slots: slots - plants!.length,
    "plants" : plants
  };

  static Future<List<Plant?>> hubPlants (String username, String hubname) async {
    return await BackendConnection.getHubPlants(username, hubname).then((response) => (jsonDecode(response.body) as List<dynamic>).map((e)
    {
      print(e);
      return e == null ? null : Plant(e["type"], e["name"], e["description"]);
    }).toList());
  }

  static int freeSlots (int slots, List<Plant?> plants ){
    int numberOfPlants = 0;
    plants.forEach((element) {
      if (element != null && element.name != ""){
        numberOfPlants++;
      }
    });
    return slots-numberOfPlants;
  }

  /// Adds this hub into the database
  ///
  /// Returns an HTTP Response which contains if the insertion was successful or not
  Future<Response> create(String owner) async {
    return await BackendConnection.createHub(owner, this);
  }


  @override
  String toString() {
    return "{" + name + "," + location + "," + slots.toString() + "}";
  }

}