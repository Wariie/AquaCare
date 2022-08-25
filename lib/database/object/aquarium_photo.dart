import 'dart:io';

import 'package:flutter/material.dart';

class AquariumPhoto {
  static const String tableName = "aquariumPhoto";

  int? id;
  late String path = "C:\\Users\\guilh\\Desktop\\maxresdefault.jpg";
  late String name;
  late int aquariumId;
  Image? image;

  AquariumPhoto({Key? key, required this.name, required this.aquariumId});

  AquariumPhoto.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"] as int;
    path = map["path"] as String;
    aquariumId = map["aquariumId"] as int;
    name = map["name"] as String;
  }

  Image getImage() {
    Image? image = Image.file(File(path));
    this.image = image;
    return image;
  }
}
