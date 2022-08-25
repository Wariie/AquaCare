abstract class Care {
  static const String typeName = "care";

  AquariumLiveType aquariumLiveType = AquariumLiveType.None;
  int id = -1;
  String name = "default";
  String scientificName = "default_scientific_name";
  String species = "default_species";
  String description = "default_description";
  int minTemperature = -1;
  int maxTemperature = -1;
  List<String> location = ["Moon"];
  int phMin = -1;
  int phMax = -1;
}

class FishCare extends Care {
  @override
  AquariumLiveType get aquariumLiveType => AquariumLiveType.Fish;
  int minSchoolSize = -1;
  int maxSchoolSize = -1;
  String swinZone = "AirBender";
  int minWaterVolum = -1;
  int minSwinLengthZone = -1;
  double livePerLiter = -1;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "id": id,
    };
    return map;
  }

  FishCare.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"] as int;
  }
}

class PlantCare extends Care {
  @override
  AquariumLiveType get aquariumLiveType => AquariumLiveType.Plant;
  String plantingType = "Normal";
  int maxSizeInCm = -1;
  int ligthningInLumenPerLiter = -1;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "id": id,
    };
    return map;
  }

  PlantCare.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"] as int;
  }
}

class InvertebrateCare extends FishCare {
  InvertebrateCare.fromMap(Map map) : super.fromMap(map);

  @override
  AquariumLiveType get aquariumLiveType => AquariumLiveType.Invertebrate;
}

enum AquariumLiveType { None, Plant, Fish, Invertebrate }
