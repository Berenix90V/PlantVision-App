import 'package:http/http.dart';
import 'package:smart_plants_app/utils/BackendConnection.dart';

import 'SensorReading.dart';

/// Defines a plant.
class Plant {
  /// A list of [SensorReading].
  ///
  /// The last one is pushed on top of the stack, and the whole history is kept to have the ability of displaying the various trends.
  final Iterable<SensorReading> sensorReadings; // TODO: Add stack

  /// The type of the plant.
  final String type;

  /// The name of the plant.
  final String name;

  /// The description of the plant.
  final String? description;

  /// Constructs a new [Plant].
  Plant._(this.sensorReadings, this.type, this.name, this.description);

  /// Retrieves and constructs a [Plant] belonging to [username].
  static Future<Plant> fetch(String username) {
    return BackendConnection.getPlant(username).then((plant) => Plant._(
        plant.getField("sensor"),
        plant.getField("type"),
        plant.getField("name"),
        plant.getField("description")));
  }

  Map<String, dynamic> get json => {
        "name": name,
        "type": type,
        "description": description,
      };

  void create(String owner) async {
    Response response = await BackendConnection.createPlant(owner, this);
    if (response.statusCode != 201) {}
  }
}
