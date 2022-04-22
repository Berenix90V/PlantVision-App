import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_plants_app/models/SensorReading.dart';
import 'package:smart_plants_app/utils/FutureObserver.dart';

/// A widget that periodically fetches the latest sensor data of a specific plant
class PeriodicSensorReader extends StatefulWidget {
  /// The user owning the plant
  @required
  final String username;

  /// The name of the plant
  @required
  final String plantName;

  const PeriodicSensorReader(
      {Key? key, required this.username, required this.plantName})
      : super(key: key);

  @override
  State<PeriodicSensorReader> createState() => _PeriodicSensorReaderState();
}

class _PeriodicSensorReaderState extends State<PeriodicSensorReader> {
  late Future<SensorReading> _latestReading;

  @override
  void initState() {
    super.initState();
    _latestReading =
        SensorReading.latestReading(widget.username, widget.plantName);
    Timer.periodic(
        const Duration(seconds: 5),
        (Timer t) => setState(() {
              _latestReading = SensorReading.latestReading(
                  widget.username, widget.plantName);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return FutureObserver<SensorReading>(
      future: _latestReading,
      onSuccess: (SensorReading reading) => reading.measurements,
      onError: (Object? e) => Text((e as Error).toString()),
    );
  }
}
