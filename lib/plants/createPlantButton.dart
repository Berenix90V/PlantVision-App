import 'package:flutter/material.dart';
import 'package:smart_plants_app/plants/plantCreator.dart';

/// Floating button that allows to add a [Plant]
class PlantAddButton extends StatefulWidget {
  @required
  final String username;
  const PlantAddButton({Key? key, required this.username}) : super(key: key);

  @override
  State<PlantAddButton> createState() => _PlantAddButtonState();
}

class _PlantAddButtonState extends State<PlantAddButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlantCreator(
                      username: widget.username,
                    ))),
        label: const Text("Create"),
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add));
  }
}
