import 'package:flutter/material.dart';
import 'package:smart_plants_app/plants/sensor/periodicSensorReader.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Plant view")),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
              child:
                  PeriodicSensorReader(username: "Silvio", plantName: "Basel")),
        ),
      ),
    );
  }
}
