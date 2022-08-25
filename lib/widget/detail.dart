import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app_test0/database/database.dart';
import 'package:flutter_app_test0/database/object/aquarium_detail.dart';

class AquariumDetailWidget extends StatefulWidget {
  final String title;
  final AquariumDetail detail;

  const AquariumDetailWidget(
      {Key? key, required this.title, required this.detail})
      : super(key: key);

  @override
  State<AquariumDetailWidget> createState() => AquariumDetailWidgetState();
}

class AquariumDetailWidgetState extends State<AquariumDetailWidget> {
  late AquariumDetail detail;
  late String title;

  AquariumDatabase aquariumDatabase = AquariumDatabase();

  AquariumDetailWidgetState({Key? key});

  @override
  void initState() {
    detail = widget.detail;
    title = widget.title;
    aquariumDatabase.open();
    super.initState();
  }

  @override
  Container build(BuildContext context) {
    return Container(
        color: Colors.blue,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(
              flex: 2,
              //width: MediaQuery.of(context).size.width / 3,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(title,
                                style: Theme.of(context).textTheme.headline6)),
                        IconButton(
                            alignment: Alignment.centerRight,
                            hoverColor: Colors.blueAccent,
                            onPressed: (() async =>
                                {await _showEditDetailMenu()}),
                            icon: const Icon(Icons.edit)),
                      ],
                    ),
                    Visibility(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Style : " + detail.style.toString(),
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.left)),
                      visible: detail.style != null,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Visibility(
                          child: Text("L : " + detail.length.toString(),
                              style: const TextStyle(fontSize: 10)),
                          visible: detail.length != null,
                        ),
                        Visibility(
                          child: Text("l : " + detail.width.toString(),
                              style: const TextStyle(fontSize: 10)),
                          visible: detail.width != null,
                        ),
                        Visibility(
                          child: Text("h : " + detail.height.toString(),
                              style: const TextStyle(fontSize: 10)),
                          visible: detail.height != null,
                        )
                      ],
                    ),
                  ]))
        ]));
  }

  Container build_old(BuildContext context) {
    return Container(
        color: Colors.blue,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(
              flex: 2,
              //width: MediaQuery.of(context).size.width / 3,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(title,
                                style: Theme.of(context).textTheme.headline6)),
                        IconButton(
                            alignment: Alignment.centerRight,
                            hoverColor: Colors.blueAccent,
                            onPressed: (() async =>
                                {await _showEditDetailMenu()}),
                            icon: const Icon(Icons.edit)),
                      ],
                    ),
                    Visibility(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Style : " + detail.style.toString(),
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.left)),
                      visible: detail.style != null,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Visibility(
                          child: Text("L : " + detail.length.toString(),
                              style: const TextStyle(fontSize: 10)),
                          visible: detail.length != null,
                        ),
                        Visibility(
                          child: Text("l : " + detail.width.toString(),
                              style: const TextStyle(fontSize: 10)),
                          visible: detail.width != null,
                        ),
                        Visibility(
                          child: Text("h : " + detail.height.toString(),
                              style: const TextStyle(fontSize: 10)),
                          visible: detail.height != null,
                        )
                      ],
                    ),
                  ])),
          Expanded(
              flex: 4,
              child: Image.asset("assets/heart_of_kalimantan_simons.jpg",
                  fit: BoxFit.fitWidth))
        ]));
  }

  _showEditDetailMenu() async {
    final TextEditingController widthCtrl = TextEditingController(),
        styleCtrl = TextEditingController(),
        heightCtrl = TextEditingController(),
        lengthCtrl = TextEditingController();
    widthCtrl.text = detail.width.toString();
    heightCtrl.text = detail.height.toString();
    lengthCtrl.text = detail.length.toString();
    styleCtrl.text = detail.style.toString();
    var r = await showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
                contentPadding: const EdgeInsets.all(8.0),
                title: Text("Edit Detail - " + title),
                children: <Widget>[
                  Row(children: [
                    const Padding(
                      child: Text("Style"),
                      padding: EdgeInsets.all(8.0),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextField(
                          selectionWidthStyle: BoxWidthStyle.max,
                          decoration: const InputDecoration(
                              labelText: 'Style', hintText: 'Australian'),
                          controller: styleCtrl,
                        ))
                  ]),
                  Row(children: [
                    const Padding(
                      child: Text("Width (cm)"),
                      padding: EdgeInsets.all(8.0),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextField(
                          selectionWidthStyle: BoxWidthStyle.max,
                          decoration: const InputDecoration(
                              labelText: 'Width (cm)', hintText: '100'),
                          controller: widthCtrl,
                        ))
                  ]),
                  Row(children: [
                    const Padding(
                      child: Text("Height (cm)"),
                      padding: EdgeInsets.all(8.0),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextField(
                          selectionWidthStyle: BoxWidthStyle.max,
                          decoration: const InputDecoration(
                              labelText: 'Height (cm)', hintText: '100'),
                          controller: heightCtrl,
                        ))
                  ]),
                  Row(children: [
                    const Padding(
                      child: Text("Length (cm)"),
                      padding: EdgeInsets.all(8.0),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextField(
                          selectionWidthStyle: BoxWidthStyle.max,
                          decoration: const InputDecoration(
                              labelText: 'Length (cm)', hintText: '100'),
                          controller: lengthCtrl,
                        ))
                  ]),
                  TextButton(
                    onPressed: () async {
                      var style = styleCtrl.text;
                      var width = widthCtrl.text;
                      var height = heightCtrl.text;
                      var length = lengthCtrl.text;
                      Navigator.pop(
                          context, ['Save', style, width, height, length]);
                    },
                    child: const Text('Save'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                ]));
    if (r[0] == 'Save') {
      setState(() {
        _editAquariumDetail(r.sublist(1));
      });
    }
  }

  Future _editAquariumDetail(List<dynamic> details) async {
    var tmpDetail = detail;
    tmpDetail.style = details[0];
    tmpDetail.width = double?.tryParse(details[1]);
    tmpDetail.height = double?.tryParse(details[2]);
    tmpDetail.length = double?.tryParse(details[3]);

    await aquariumDatabase.edit(AquariumDetail.typeName, tmpDetail);
    setState(() {
      detail = tmpDetail;
    });
  }
}
