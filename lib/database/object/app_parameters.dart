import 'package:flutter/material.dart';

class AppParameters {
  static const String tableName = "appParameters";

  String temperatureScaleUnit = "C"; //"Celcius, Fareinheight, Kelvin"
  String lengthScaleUnit = "m"; //Meter, Inch,
  String waterVolumeScaleUnit = "L"; //Gallon

  AppParameters(
      {Key? key,
      required this.temperatureScaleUnit,
      required this.lengthScaleUnit,
      required this.waterVolumeScaleUnit});
}
