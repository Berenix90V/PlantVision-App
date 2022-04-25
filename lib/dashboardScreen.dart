import 'package:flutter/material.dart';
import 'package:smart_plants_app/utils/FutureObserver.dart';

import 'dashboardPlants.dart';
import 'hubs/createHubButton.dart';
import 'models/Hub.dart';
import 'models/User.dart';

/// Dashboard of all hubs for a user
class DashboardScreen extends StatefulWidget {
  @required
  final String username;
  const DashboardScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Hub>> hubs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hubs = User.userHubs(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Hubs'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: HubAddButton(username: widget.username),
        // builds list of hubs
        body: FutureObserver<List<Hub>>(
          future: hubs,
          onSuccess: (List<Hub> hs) => ListView.builder(
              itemCount: hs.length,
              itemBuilder: (context, index) {
                Hub hub = hs.elementAt(index);
                int freeSlots = Hub.freeSlots(hub.slots, hub.plants!);
                return ListTile(
                  // TODO: try with custom icons
                  leading: const Icon(Icons.hub, color: Colors.green),
                  title: Text(hub.name),
                  subtitle: Text(hub.location),
                  trailing: freeSlots != 0
                      ? const Icon(Icons.spa, color: Colors.green)
                      : const Icon(Icons.spa),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardPlants(
                              hubname: hub.name,
                              username: widget.username,
                              freeSlots: freeSlots),
                          maintainState: false)),
                );
              }),
          onError: (error) => const Center(child: Text("An error occurred")),
        ));
  }
}
