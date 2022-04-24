import 'package:flutter/material.dart';
import 'package:smart_plants_app/plants/createPlantButton.dart';

import 'dashboardPlants.dart';
import 'hubs/createHubButton.dart';
import 'models/Hub.dart';
import 'models/Plant.dart';
import 'models/User.dart';

/// Dashboard of all hubs for a user
class DashboardScreen extends StatelessWidget {
  @required
  final String username;
  const DashboardScreen({Key? key, required this.username}) : super(key: key);

  //TODO: fix API documentation of return user data from "Temeperature" to "Temperature"

  @override
  Widget build(BuildContext context) {
    Future <List<Hub>> hubs = User.userHubs(username);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Hubs'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: HubAddButton(username: username),
      // builds list of hubs
        //TODO REFACTOR DEL FUTURE BUILDER eccezione null check
      body: FutureBuilder<List<Hub>>(
        future: hubs,
        builder: (context, AsyncSnapshot<List<Hub?>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index){
                  if(snapshot.data!.elementAt(index) != null){
                    Hub? hub = snapshot.data!.elementAt(index)!;
                    int freeSlots = Hub.freeSlots(hub.slots, hub.plants!);
                    return ListTile(
                      // TODO: try with custom icons
                      leading: const Icon(Icons.hub, color: Colors.green),
                      title: Text(hub.name),
                      subtitle: Text(hub.location),
                      trailing: freeSlots !=0? const Icon(Icons.spa, color: Colors.green): const Icon(Icons.spa),
                      onTap: ()=>
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DashboardPlants(hubname: hub.name, username: username, freeSlots: freeSlots))),
                    );
                  } else {
                    return const Text("Empty hub");
                  }
                });
          } else {
            return Text((snapshot.error! as TypeError).stackTrace.toString()) ;
          }
        }
      )
    );
  }
}
