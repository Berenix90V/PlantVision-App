import 'package:flutter/material.dart';
import 'package:smart_plants_app/plants/plantCreator.dart';

import 'hubCreator.dart';

/// Floating button that allows to add a [Hub]
class HubAddButton extends StatefulWidget {
  @required
  final String username;
  const HubAddButton({Key? key, required this.username}) : super(key: key);

  @override
  State<HubAddButton> createState() => _HubAddButtonState();
}

class _HubAddButtonState extends State<HubAddButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HubCreator(
                    username: widget.username,
                ))),
        label: const Text("Create"),
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add));
  }
}
