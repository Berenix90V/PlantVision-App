import 'package:flutter/material.dart';
import 'package:smart_plants_app/plants/createPlantButton.dart';

import 'dashboardPlants.dart';
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
        title: const Text('Your Plants'),
      ),
      // builds list of hubs
      body: FutureBuilder<List<Hub>>(
        future: hubs,
        builder: (context, AsyncSnapshot<List<Hub>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index){
                  if(snapshot.data!.elementAt(index) != null){
                    List<Plant>? hubPlants = snapshot.data!.elementAt(index).plants;
                    return ListTile(
                      // TODO: try with custom icons
                      leading: const Icon(Icons.hub),
                      title: Text(snapshot.data!.elementAt(index).name),
                      trailing: Text(snapshot.data!.elementAt(index).location),
                      onTap: ()=>
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DashboardPlants(hubname: snapshot.data!.elementAt(index).name, username: username,))),
                    );
                  } else {
                    return const Text("Empty hub");
                  }

                });
          } else {
            return const Text("Error") ;
          }
        }
      )
    );
  }
}
