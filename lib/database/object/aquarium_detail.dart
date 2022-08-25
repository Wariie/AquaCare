import 'package:flutter/material.dart';

class AquariumDetail {
  static const String typeName = "aquariumDetail";

  late int id;
  double? width;
  double? length;
  double? height;
  double? volume;
  String? style;
  String? heatingSystem;
  String? filtrationSystem;
  String? ligthingSystem;
  String? aquariumName;
  late int aquariumId;

  AquariumDetail({Key? key, required this.id, required this.aquariumId});

  Map<String, Object?> toMap() {
    var idToSet;
    if (id != -1) {
      idToSet = id;
    }
    var map = {
      "id": idToSet,
      "width": height,
      "length": length,
      "height": height,
      "volume": volume,
      "style": style,
      "heatingSystem": heatingSystem,
      "filtrationSystem": filtrationSystem,
      "ligthingSystem": ligthingSystem,
      "aquariumName": aquariumName,
      "aquariumId": aquariumId
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  AquariumDetail.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"] as int;
    height = map["height"] as double?;
    length = map["length"] as double?;
    width = map["width"] as double?;
    volume = map["volume"] as double?;
    style = map["style"] as String?;
    aquariumId = map["aquariumId"] as int;
    heatingSystem = map["heatingSystem"] as String?;
    filtrationSystem = map["filtrationSystem"] as String?;
    ligthingSystem = map["ligthingSystem"] as String?;
    aquariumName = map["aquariumName"] as String?;
  }
}
