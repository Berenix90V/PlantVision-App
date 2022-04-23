import 'package:flutter/material.dart';
import 'package:smart_plants_app/plants/sensor/periodicSensorReader.dart';
import 'package:smart_plants_app/utils/FutureObserver.dart';

import 'models/Plant.dart';

/// Defines a dashboard for a single [Plant], showing the name, the type, its description if any, and
/// the sensor readings updated every 5 seconds.
///
/// See: [PeriodicSensorReader].
class DashboardScreenSingle extends StatelessWidget {
  /// The username of the plant owner
  @required
  final String username;

  /// The name of the plant
  @required
  final String plantName;

  const DashboardScreenSingle(
      {Key? key, required this.username, required this.plantName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard of $plantName"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: FutureObserver<Plant>(
            future: Plant.fetch(username, plantName),
            onSuccess: (Plant plant) => Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Text(
                        plant.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10)),
                    Chip(
                      label: Text(
                        plant.type,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  ],
                ),
                plant.description != null
                    ? Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 10, right: 10),
                        child: Center(
                            child: Text(
                          plant.description!,
                          softWrap: true,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        )),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40)),
                Expanded(
                    child: PeriodicSensorReader(
                        username: username, plantName: plantName))
              ],
            ),
            onError: (error) => Center(child: Text(error.toString())),
          )),
        ),
      ),
    );
  }
}
