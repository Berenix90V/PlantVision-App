import 'package:flutter/material.dart';
import 'package:smart_plants_app/plants/textField.dart';
import 'package:smart_plants_app/utils/BackendConnection.dart';

import '../models/Plant.dart';

/// A form that allows to create and insert a new [Plant] into the database
class PlantCreator extends StatefulWidget {
  /// The username of the user whose plant will be assigned
  @required
  final String username;

  const PlantCreator({Key? key, required this.username}) : super(key: key);

  @override
  State<PlantCreator> createState() => _PlantCreatorState();
}

class _PlantCreatorState extends State<PlantCreator> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new plant"),
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
                PlantCreatorTextField(
                  controller: nameController,
                  label: "Name",
                  validation: (value) => value == null || value.isEmpty
                      ? "Name cannot be empty"
                      : null,
                ),
                PlantCreatorTextField(
                  controller: typeController,
                  label: "Type",
                  validation: (value) => value == null || value.isEmpty
                      ? "Type cannot be empty"
                      : null,
                ),
                PlantCreatorTextField(
                  controller: descriptionController,
                  label: "Description",
                  validation: (value) => null,
                  minLines: 3,
                  maxLines: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: ElevatedButton(
                    onPressed: () async {
                      final response = await Plant(typeController.text,
                              nameController.text, descriptionController.text)
                          .create(widget.username);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(response.getField("message"))));
                    },
                    child: const Text("Create plant"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
