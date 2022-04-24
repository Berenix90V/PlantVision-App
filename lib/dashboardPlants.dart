import 'package:flutter/material.dart';
import 'package:smart_plants_app/dashboardSingle.dart';
import 'package:smart_plants_app/plants/createPlantButton.dart';

import 'models/Hub.dart';
import 'models/Plant.dart';
import 'models/User.dart';

class DashboardPlants extends StatefulWidget {
  @required
  final String username;

  @required
  final String hubname;

  @required
  final int freeSlots;

  const DashboardPlants({Key? key, required this.username, required this.hubname, required this.freeSlots}) : super(key: key);

  @override
  State<DashboardPlants> createState() => _DashboardPlantsState();
}

class _DashboardPlantsState extends State<DashboardPlants> {
  late final Future <List<Plant?>> plants;

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
        floatingActionButton: widget.freeSlots!=0? PlantAddButton(username: widget.username, hubname: widget.hubname,): null,
        //TODO REFACTOR DEL FUTURE BUILDER eccezione null check
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
                                          DashboardScreenSingle(plantName: snapshot.data!.elementAt(index)!.name, username: widget.username, hub: widget.hubname))),
                        );
                      } else {
                        return Container();
                      }

                    });
              } else {
                return Text((snapshot.error as TypeError?)?.stackTrace.toString() ?? "NULL") ;
              }
            }
        )
    );
  }
}