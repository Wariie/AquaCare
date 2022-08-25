import 'package:flutter/material.dart';

class AquariumMeasurementsPage extends StatefulWidget {
  const AquariumMeasurementsPage(
      {Key? key, required this.aquariumName, required this.idAquarium})
      : super(key: key);

  final String aquariumName;
  final int idAquarium;

  @override
  State<AquariumMeasurementsPage> createState() =>
      _AquariumMeasurementsPageState();
}

class _AquariumMeasurementsPageState extends State<AquariumMeasurementsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          child: Text(widget.aquariumName + " Last Measurements"),
        ),
      ],
    ));
  }
}
