import 'package:flutter_app_test0/database/database.dart';

import '../database/object/measure.dart';

class MeasureTools {
  static MeasureParameter getMeasureMeasureParameterName(
      Measure m, List<MeasureParameter> parameters) {
    for (MeasureParameter parameter in parameters) {
      if (parameter.id == m.measureParameterId) {
        return parameter;
      }
    }
    return MeasureParameter(acronym: "Error", name: "Error");
  }

  static Future<List<MeasureParameter>> getParameters(
      AquariumDatabase aquariumDatabase) async {
    List<MeasureParameter> tmpParameters = <MeasureParameter>[];
    List<Map<dynamic, dynamic>> tmpMapParameters =
        await aquariumDatabase.list(MeasureParameter.typeName);
    for (Map p in tmpMapParameters) {
      tmpParameters.add(MeasureParameter.fromMap(p));
    }
    return tmpParameters;
  }

  static Future<List<Measure>> getMeasureFromMeasurements(
      Measurements m, AquariumDatabase aquariumDatabase) async {
    List<Measure> measureList = <Measure>[];

    List<Map> tmpList = await aquariumDatabase.listWhere(
        Measure.typeName, m.id as int,
        column: "measurementsParentId");
    for (Map mp in tmpList) {
      measureList.add(Measure.fromMap(mp));
    }
    return measureList;
  }
}
