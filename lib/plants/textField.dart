import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef ValidationFunction = String? Function(String?);

/// [TextFormField] wrapper with predefined style in line with the general theme of the application
class PlantCreatorTextField extends StatefulWidget {
  /// The controller
  @required
  final TextEditingController controller;

  /// The label to be displayed to help the user understand the functionality of the field
  @required
  final String label;

  /// A validation function
  @required
  final ValidationFunction validation;

  /// The minimum number of lines in the text field
  final int? minLines;

  /// The maximum number of lines in the text field.
  ///
  /// Note: `minLines <= maxLines`
  final int? maxLines;

  const PlantCreatorTextField(
      {Key? key,
      required this.controller,
      required this.label,
      required this.validation,
      this.minLines,
      this.maxLines})
      : super(key: key);

  @override
  State<PlantCreatorTextField> createState() => _PlantCreatorTextFieldState();
}

class _PlantCreatorTextFieldState extends State<PlantCreatorTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
        ),
        validator: widget.validation,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
      ),
    );
  }
}


class HubCreatorTextField extends StatefulWidget {
  /// The controller
  @required
  final TextEditingController controller;

  /// The label to be displayed to help the user understand the functionality of the field
  @required
  final String label;

  /// A validation function
  @required
  final ValidationFunction validation;

  /// The minimum number of lines in the text field
  final int? minLines;

  /// The maximum number of lines in the text field.
  ///
  /// Note: `minLines <= maxLines`
  final int? maxLines;

  final bool isInteger;

  const HubCreatorTextField(
      {Key? key,
        required this.controller,
        required this.label,
        required this.validation,
        this.minLines,
        this.maxLines,
        this.isInteger=false,
      })
      : super(key: key);

  @override
  State<HubCreatorTextField> createState() => _HubCreatorTextFieldState();
}

class _HubCreatorTextFieldState extends State<HubCreatorTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
        ),
        validator: widget.validation,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        inputFormatters: widget.isInteger ? [FilteringTextInputFormatter.digitsOnly]: null,
      ),
    );
  }
}
