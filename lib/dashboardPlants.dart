import 'package:flutter/material.dart';
import 'package:smart_plants_app/dashboardSingle.dart';
import 'package:smart_plants_app/plants/createPlantButton.dart';

import 'models/Hub.dart';
import 'models/Plant.dart';
import 'models/User.dart';

class DashboardPlants extends StatelessWidget {
  @required
  final String username;

  @required
  final String hubname;
  const DashboardPlants({Key? key, required this.username, required this.hubname}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Future <List<Plant?>> plants = Hub.hubPlants(username, hubname);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Hubs'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: FutureBuilder<List<Plant?>>(
            future: plants,
            builder: (context, AsyncSnapshot<List<Plant?>> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index){
                      if(snapshot.data!.elementAt(index) != null){
                        return ListTile(
                          // TODO: try with custom icons
                          leading: const Icon(Icons.spa, color: Colors.green),
                          title: Text(snapshot.data!.elementAt(index)!.name),
                          subtitle: Text(snapshot.data!.elementAt(index)!.type),
                          onTap: ()=>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DashboardScreenSingle(plantName: snapshot.data!.elementAt(index)!.name, username: username, hub: hubname))),
                        );
                      } else {
                        return Container();
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