import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_plants_app/plants/textField.dart';
import 'package:smart_plants_app/utils/BackendConnection.dart';

import '../models/Hub.dart';

class HubCreator extends StatefulWidget {
  @required
  final String username;
  const HubCreator({Key? key, required this.username}) : super(key: key);

  @override
  State<HubCreator> createState() => _HubCreatorState();
}

class _HubCreatorState extends State<HubCreator> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController slotsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new hub"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                HubCreatorTextField(
                  controller: nameController,
                  label: "Name",
                  validation: (value) => value == null || value.isEmpty
                      ? "Name cannot be empty"
                      : null,
                ),
                HubCreatorTextField(
                  controller: locationController,
                  label: "Location",
                  validation: (value) => value == null || value.isEmpty
                      ? "Location cannot be empty"
                      : null,
                ),
                HubCreatorTextField(
                  controller: slotsController,
                  label: "Number of slots",
                  isInteger: true,
                  validation: (value) => value == null || value.isEmpty
                      ? "Number of slots cannot be empty"
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: ElevatedButton(
                    onPressed: () async {
                      final response = await Hub(nameController.text,
                          locationController.text, int.parse(slotsController.text), null)
                          .create(widget.username);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(response.getField("message"))));
                    },
                    child: const Text("Create hub"),
                  ),
                )
              ],
            ),

          )

        )
      ),
    );
  }
}
