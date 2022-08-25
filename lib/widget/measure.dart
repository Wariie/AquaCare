import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../database/database.dart';
import '../database/object/measure.dart';
import '../tools/measure.dart';

class MeasureWidget extends StatefulWidget {
  final int aquariumId;

  const MeasureWidget({Key? key, required this.aquariumId}) : super(key: key);

  @override
  State<MeasureWidget> createState() => MeasureWidgetState();
}

class MeasureWidgetState extends State<MeasureWidget> {
  final AquariumDatabase aquariumDatabase = AquariumDatabase();

  late Measurements? lastMeasurements;
  late Future<List<Measure>?> measures;
  late List<MeasureParameter> parameters;
  late int aquariumId;

  createState() {}

  @override
  void initState() {
    super.initState();
    aquariumId = widget.aquariumId;
    aquariumDatabase.open();
    getParameters();
    measures = getLastMeasures(aquariumId);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          Container(
              color: Colors.blueAccent,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("        "),
                    const Text(
                      "Measurements",
                      textAlign: TextAlign.start,
                    ),
                    IconButton(
                        alignment: Alignment.centerRight,
                        hoverColor: Colors.white,
                        onPressed: (() => _showMenuMeasurements(aquariumId)),
                        icon: const Icon(Icons.edit))
                  ])),
          generateFutureMeasuresList()
        ]));
  }

  Future getParameters() async {
    parameters = await MeasureTools.getParameters(aquariumDatabase);
  }

  Future<Measurements?> getLastMeasurements(int aquariumId) async {
    Map? m = await aquariumDatabase.lastInsert(Measurements.typeName,
        whereColumn: "idAquarium", whereValue: aquariumId);
    if (m == null) return null;
    return Measurements.fromMap(m);
  }

  Future<List<Measure>?> getLastMeasures(int aquariumId) async {
    lastMeasurements = await getLastMeasurements(aquariumId);
    if (lastMeasurements != null) {
      return MeasureTools.getMeasureFromMeasurements(
          lastMeasurements as Measurements, aquariumDatabase);
    }
    return null;
  }

  String generateMeasureString(Measure m) {
    MeasureParameter p =
        MeasureTools.getMeasureMeasureParameterName(m, parameters);
    return p.acronym + " - " + p.name;
  }

  Color? getRandomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)]
        [Random().nextInt(9) * 100];
  }

  Widget generateFutureMeasuresList() {
    return FutureBuilder(
        future: measures,
        initialData: const <Measure>[],
        builder:
            (BuildContext context, AsyncSnapshot<List<Measure>?> snapshot) {
          if (!snapshot.hasData) {
            return const Text("No measurements or measures found.");
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                var color = getRandomColor();
                return Chip(
                    shadowColor: Colors.blue,
                    elevation: 2,
                    label: Text(generateMeasureString(snapshot.data![index]) +
                        " : " +
                        snapshot.data![index].value),
                    backgroundColor: color);
                /*return Material(
                    shadowColor: Colors.blue,
                    color: color,
                    elevation: 2,
                    child: ListTile(
                      leading:
                          Text(generateMeasureString(snapshot.data![index])),
                      trailing: Text(snapshot.data![index].value),
                    ));*/
              }));
        });
  }

  _databaseAdd(Measurements m, List<Measure> measures) async {
    int id = await aquariumDatabase.add(Measurements.typeName, m, "id");
    for (Measure fMeasure in measures) {
      fMeasure.measurementsParentId = id;
      //int sId = await aquariumDatabase.add(Measure.typeName, fMeasure, "id");
      await aquariumDatabase.add(Measure.typeName, fMeasure, "id");
    }
  }

  _showMenuMeasurements(int aquariumId,
      {Measurements? m,
      AquariumDatabase? aquariumDatabase,
      String action = "Add"}) async {
    TextEditingController _textFieldController = TextEditingController();
    List<Measure> measures = <Measure>[];
    MeasureParameter pSelected = parameters[0];
    if (action == "Add") {
      DateTime date = DateTime.now();
      date = DateTime(date.year, date.month, date.day);
      m = Measurements(date: date, idAquarium: aquariumId);
    } else if (action == "Edit") {
      measures =
          await MeasureTools.getMeasureFromMeasurements(m!, aquariumDatabase!);
    }
    var r = await showDialog<String>(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              contentPadding: const EdgeInsets.all(16.0),
              content: SizedBox(
                  width: MediaQuery.of(context).size.width / 10 * 8,
                  height: MediaQuery.of(context).size.height,
                  child: Column(children: [
                    Text("(new) " + m!.date.toString() + " Measurements"),
                    ListView.builder(
                        itemCount: measures.length,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          return Material(
                              shadowColor: Colors.blue,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Row(children: [
                                    Text(
                                        generateMeasureString(measures[index])),
                                    Text(measures[index].value),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: (() => {}),
                                    ),
                                  ])));
                        })),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                              flex: 1,
                              child: DropdownButton<MeasureParameter>(
                                isExpanded: true,
                                value: pSelected,
                                alignment: Alignment.centerLeft,
                                icon: const Icon(Icons.arrow_drop_down),
                                elevation: 4,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 1,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (MeasureParameter? newValue) {
                                  setState(() {
                                    pSelected = newValue as MeasureParameter;
                                  });
                                },
                                items: parameters
                                    .map<DropdownMenuItem<MeasureParameter>>(
                                        (MeasureParameter value) {
                                  return DropdownMenuItem<MeasureParameter>(
                                      alignment: Alignment.centerLeft,
                                      value: value,
                                      child: Text(value.acronym.toString()));
                                }).toList(),
                              )),
                          Expanded(
                              flex: 1,
                              child: TextField(
                                selectionWidthStyle: BoxWidthStyle.tight,
                                controller: _textFieldController,
                                autofocus: true,
                                decoration: const InputDecoration(
                                    labelText: 'Aquarium',
                                    hintText: 'New Aquarium'),
                              )),
                          Expanded(
                              flex: 1,
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _addMeasureToList(
                                          measures,
                                          Measure(
                                              measureParameterId:
                                                  pSelected.id as int,
                                              measurementsParentId: 0,
                                              value:
                                                  _textFieldController.text));
                                    });
                                  },
                                  child: const Text("Add")))
                        ]),
                  ])),
              actions: [
                TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => {Navigator.pop(context, "Cancel")}),
                TextButton(
                    child: Text(action),
                    onPressed: () {
                      Navigator.pop(context, action);
                    })
              ],
            );
          });
        });
    if (r == action) {
      _databaseAdd(m!, measures);
    }
  }

  List<Measure> _addMeasureToList(List<Measure> measures, Measure m) {
    for (Measure fMeasure in measures) {
      if (fMeasure.measureParameterId == m.measureParameterId) {
        fMeasure.value = m.value;
        return measures;
      }
    }
    measures.add(m);
    return measures;
  }
}
