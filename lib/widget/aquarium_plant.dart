import 'package:flutter_app_test0/database/database.dart';

import '../database/object/care.dart';

Future<List<PlantCare>> getPlants(
    int aquariumId, AquariumDatabase aquariumDatabase) async {
  var list = <PlantCare>[];
  var tmpList = await aquariumDatabase.listWhere(Care.typeName, aquariumId,
      column: "aquariumCareId");
  for (var p in tmpList) {
    list.add(PlantCare.fromMap(p));
  }
  return list;
}
