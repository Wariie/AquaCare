import 'package:flutter/material.dart';

class Measurements {
  int? id;
  late DateTime date;
  late int idAquarium;

  static const String typeName = "measurements";

  Measurements({Key? key, required this.date, required this.idAquarium});

  Map<String, Object?> toMap() {
    return <String, Object?>{
      "date": date.millisecondsSinceEpoch,
      "id": id,
      "idAquarium": idAquarium,
    };
  }

  Measurements.fromMap(Map<dynamic, dynamic> map) {
    date = DateTime.fromMillisecondsSinceEpoch(map["date"] as int);
    id = map["id"] as int;
    idAquarium = map["idAquarium"] as int;
  }
}

class Measure {
  static const String typeName = "measure";

  int? id;
  late int measurementsParentId;
  late String value;
  late int measureParameterId;

  Measure(
      {Key? key,
      required this.measureParameterId,
      required this.measurementsParentId,
      required this.value});

  Map<String, Object?> toMap() {
    return <String, Object?>{
      "measureParameterId": measureParameterId,
      "id": id,
      "measurementsParentId": measurementsParentId,
      "value": value
    };
  }

  Measure.fromMap(Map<dynamic, dynamic> map) {
    measureParameterId = map["measureParameterId"] as int;
    id = map["id"] as int;
    measurementsParentId = map["measurementsParentId"] as int;
    value = map["value"];
  }
}

class MeasureParameter {
  static const String typeName = "measureParameter";

  int? id;
  late String acronym = "default";
  late String name = "default";
  //String description = "default"; NEXT ITERATION
  //String mesureFormula = "default"; NEXT ITERATION

  MeasureParameter({Key? key, required this.acronym, required this.name});

  Map<String, Object?> toMap() {
    return <String, Object?>{
      "id": id,
      "name": name,
      "acronym": acronym,
    };
  }

  MeasureParameter.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"] as int;
    name = map["name"] as String;
    acronym = map["acronym"] as String;
  }
}

List<MeasureParameter> getDefaultParameters() {
  List<MeasureParameter> parameters = <MeasureParameter>[];
  parameters.add(MeasureParameter(acronym: "pH", name: "potentiel Hydrogène"));
  parameters.add(MeasureParameter(acronym: "kH", name: "Alcalinité"));
  parameters.add(MeasureParameter(acronym: "GH", name: "Dureté"));
  parameters.add(MeasureParameter(acronym: "fe", name: "Fer"));
  parameters.add(MeasureParameter(acronym: "mg", name: "Magnesium"));
  parameters.add(MeasureParameter(acronym: "k", name: "Kallium-Potassium"));
  parameters.add(MeasureParameter(acronym: "po4", name: "Phosphate"));
  parameters.add(MeasureParameter(acronym: "no3", name: "Nitrates"));
  parameters.add(MeasureParameter(acronym: "no2", name: "Nitrites"));
  parameters.add(MeasureParameter(acronym: "nh3", name: "Ammoniaque"));
  parameters.add(MeasureParameter(acronym: "density", name: "Densité"));
  parameters.add(MeasureParameter(acronym: "cu", name: "Cuivre"));
  parameters.add(MeasureParameter(acronym: "o2", name: "Oxygène"));
  parameters.add(MeasureParameter(acronym: "co2", name: "CO2"));
  parameters.add(MeasureParameter(acronym: "nh4", name: "Ammonium"));
  return parameters;
}

/* list Measurements parameters : pH,kH,gh, fe, mg, k, ca, po4, sio2, density, no3, no2, nh3
  */