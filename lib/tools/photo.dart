import 'package:flutter_app_test0/database/object/aquarium_photo.dart';

import '../database/database.dart';
import '../database/object/aquarium.dart';

class PhotoTools {
  static Future<dynamic> getLastAquariumPhoto(
      Aquarium aqua, AquariumDatabase aquariumDatabase,
      {bool favorite = false}) async {
    List<Map> results = await aquariumDatabase.lastInsert(
        AquariumPhoto.tableName,
        whereColumn: "aquariumId",
        whereValue: aqua.id);
    AquariumPhoto? photo = AquariumPhoto.fromMap(results[0]);
    return photo.getImage();
  }
}
