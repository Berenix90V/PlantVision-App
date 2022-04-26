import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_plants_app/models/SensorReading.dart';
import 'package:smart_plants_app/utils/FutureObserver.dart';

/// A widget that fetches the latest sensor data of a specific plant every 5 seconds
class PeriodicSensorReader extends StatefulWidget {
  /// The user owning the plant
  @required
  final String username;

  /// The name of the plant
  @required
  final String plantName;

  /// The name of the hub
  @required
  final String hub;

  const PeriodicSensorReader(
      {Key? key,
      required this.username,
      required this.plantName,
      required this.hub})
      : super(key: key);

  @override
  State<PeriodicSensorReader> createState() => _PeriodicSensorReaderState();
}

class _PeriodicSensorReaderState extends State<PeriodicSensorReader> {
  late Future<SensorReading?> _latestReading;

  /// To prevent errors when requesting periodically data, the state is set only
  /// when the component has been fully loaded
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _latestReading = SensorReading.latestReading(
        widget.username, widget.plantName, widget.hub);
    Timer.periodic(
        const Duration(seconds: 5),
        (Timer t) => setState(() {
              _latestReading = SensorReading.latestReading(
                  widget.username, widget.plantName, widget.hub);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return FutureObserver<SensorReading?>(
      future: _latestReading,
      onSuccess: (SensorReading? reading) => reading!.measurements,
      onError: (Object? e) => Text((e as Error).toString()),
      onWaiting: () => const Center(
        child: Text("No readings found"),
      ),
    );
  }
}
