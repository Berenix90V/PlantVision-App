import 'package:flutter/material.dart';
import 'package:smart_plants_app/dashboardSingle.dart';
import 'package:smart_plants_app/plants/createPlantButton.dart';
import 'package:smart_plants_app/utils/FutureObserver.dart';

import 'models/Hub.dart';
import 'models/Plant.dart';

class DashboardPlants extends StatefulWidget {
  @required
  final String username;

  @required
  final String hubname;

  @required
  final int freeSlots;

  const DashboardPlants(
      {Key? key,
      required this.username,
      required this.hubname,
      required this.freeSlots})
      : super(key: key);

  @override
  State<DashboardPlants> createState() => _DashboardPlantsState();
}

class _DashboardPlantsState extends State<DashboardPlants> {
  late final Future<List<Plant?>> plants;

  @override
  initState() {
    super.initState();
    plants = Hub.hubPlants(widget.username, widget.hubname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Plants'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: widget.freeSlots != 0
            ? PlantAddButton(
                username: widget.username,
                hubname: widget.hubname,
              )
            : null,
        body: FutureObserver<List<Plant?>>(
          future: plants,
          onSuccess: (List<Plant?> ps) {
            Iterable<Plant?> existingPlants = ps.where((p) => p != null);
            return ListView.builder(
                itemCount: existingPlants.length,
                itemBuilder: (context, index) {
                  Plant? plant = existingPlants.elementAt(index);
                  if (plant != null) {
                    return ListTile(
                      // TODO: try with custom icons
                      leading: const Icon(Icons.spa, color: Colors.green),
                      title: Text(plant.name),
                      subtitle: Text(plant.type),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardScreenSingle(
                                  plantName: plant.name,
                                  username: widget.username,
                                  hub: widget.hubname),
                              maintainState: false)),
                    );
                  } else {
                    return Container();
                  }
                });
          },
          onError: (error) => const Center(child: Text("An error occurred")),
        ));
  }
}
