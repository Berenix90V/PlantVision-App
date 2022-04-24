import 'dart:async';

import 'package:http/http.dart';
import 'package:smart_plants_app/utils/BackendConnection.dart';

import 'SensorReading.dart';

/// Defines a plant.
class Plant {
  /// A list of [SensorReading].
  ///
  /// The last one is pushed on top of the stack, and the whole history is kept to have the ability of displaying the various trends.
  final List<SensorReading>? sensorReadings; // TODO: Add stack

  /// The type of the plant.
  final String type;

  /// The name of the plant.
  final String name;

  /// The description of the plant.
  final String? description;

  /// Constructs a new [Plant].
  Plant(this.type, this.name, this.description, {this.sensorReadings});

  /// Retrieves and constructs a [Plant] belonging to [username].
  static Future<Plant> fetch(String username, String plantName, String hub) {
    return BackendConnection.getPlant(username, plantName, hub).then((plant) =>
        Plant(plant.getField("plantType"), plant.getField("name"),
            plant.getField("description", required: false),
            sensorReadings: []));
  }

  /// Returns the JSON representation of this plant
  Map<String, dynamic> get json => {
        "name": name,
        "type": type,
        "description": description,
      };

  /// Adds this plant into the database
  ///
  /// Returns an HTTP Response which contains if the insertion was successful or not
  Future<Response> create(String owner) async {
    return await BackendConnection.createPlant(owner, this);
  }
}
