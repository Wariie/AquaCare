import 'package:flutter/material.dart';

class Aquarium {
  static const String typeName = "aquarium";

  String name = "New Aquarium";
  int id = -999;

  Aquarium({Key? key, required this.name, required this.id});

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "name": name,
    };
    map["id"] = id;
    return map;
  }

  Aquarium.fromMap(Map<dynamic, dynamic> map) {
    name = map["name"] as String;
    id = map["id"] as int;
  }
}
