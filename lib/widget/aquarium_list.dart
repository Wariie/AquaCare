import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app_test0/page/aquarium_detail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../database/database.dart';
import '../database/object/aquarium.dart';
import '../database/object/aquarium_detail.dart';
import '../database/object/aquarium_photo.dart';
import '../dialog/custom_dialog.dart';

@immutable
class AquariumListWidget extends StatefulWidget {
  const AquariumListWidget({Key? key}) : super(key: key);

  @override
  _AquariumListWidgetState createState() => _AquariumListWidgetState();
}

class _AquariumListWidgetState extends State<AquariumListWidget> {
  late List<Aquarium> _aquarium = <Aquarium>[];
  late List<Image> _aquariumPhotos = <Image>[];

  final AquariumDatabase aquariumDatabase = AquariumDatabase();

  final TextEditingController eCtrl = TextEditingController();

  _AquariumListWidgetState();

  @override
  void initState() {
    super.initState();
    aquariumDatabase.open();
    _fetchAquariumList();
  }

  @override
  void dispose() {
    super.dispose();
    aquariumDatabase.close();
  }

  void _addAquariumN() async {
    String name = await _showAquariumEditName(true);
    _addAquarium(name);
  }

  void _addAquarium(String text) async {
    if (text.isEmpty) return;
    var aqua = Aquarium(name: text, id: _aquarium.length + 1);
    int id = await aquariumDatabase.add(Aquarium.typeName, aqua, null);

    var aquaDetail = AquariumDetail(id: -1, aquariumId: id);
    await aquariumDatabase.add(AquariumDetail.typeName, aquaDetail, null);
    setState(() {
      _aquarium.add(aqua);
    });
    eCtrl.clear();
  }

  Future<bool> _editAquariumName(int index) async {
    String name =
        await _showAquariumEditName(false, name: _aquarium[index].name);
    if (name.isEmpty) return false;

    var a = _aquarium[index];
    a.name = name;
    aquariumDatabase.edit(Aquarium.typeName, a);
    setState(() {
      _aquarium[index] = a;
    });
    return true;
  }

  Future<List<Image>> getAquariumsImages() async {
    List<Image> photos = <Image>[];
    for (var aqua in _aquarium) {
      photos.add(AquariumPhoto(
        aquariumId: aqua.id,
        name: "test",
      ).getImage());
    }
    _aquariumPhotos = photos;
    return photos;
  }

  //TO BE REBUILD ( DELETE ALL ASSETS IN ALL TABLE WITH THIS AQUARIUM ID AND SUBTABLES
  //Aquarium
  //AquariumDetail
  //Measurements -> Measure

  Future<bool> _delAquarium(int index) async {
    var aqua = _aquarium[index];
    if (await CustomDialog.showConfirmationDialog(context, "Delete",
        "Do you want to delete Aquarium - " + _aquarium[index].name)) {
      aquariumDatabase.del(Aquarium.typeName, aqua);
      setState(() {
        _aquarium.remove(aqua);
      });
      return true;
    }
    return false;
  }

  Future _fetchAquariumList() async {
    List<Aquarium> list = <Aquarium>[];
    var dblist = await aquariumDatabase.list("aquarium");
    for (var e in dblist) {
      list.add(Aquarium.fromMap(e));
    }
    var photos = await getAquariumsImages();
    setState(() {
      _aquarium = list;
      _aquariumPhotos = photos;
    });
  }

  _showAquariumMenu(int index) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              alignment: Alignment.bottomCenter,
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Menu - " + _aquarium[index].name,
                textAlign: TextAlign.center,
              ),
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextButton(
                          clipBehavior: Clip.none,
                          onPressed: () async {
                            await _editAquariumName(index);
                            Navigator.pop(context, 'Edit');
                          },
                          child: const Text('Edit'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _delAquarium(index);
                            Navigator.pop(context, 'Delete');
                          },
                          child: const Text('Delete'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                      ]),
                )
              ],
            ));
  }

  _showAquariumEditName(bool action, {name = ""}) async {
    TextEditingController _textFieldController = TextEditingController();
    String resultName = "";

    //true add
    //false edit
    String validateButtonText = "Add";
    if (!action) {
      validateButtonText = "Edit";
      _textFieldController.text = name;
    }

    if (await showDialog<String>(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
              shape:
                  const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
              alignment: Alignment.bottomCenter,
              insetPadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(8.0),
              children: [
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.zero, color: Colors.white),
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(children: [
                    TextField(
                      selectionWidthStyle: BoxWidthStyle.max,
                      controller: _textFieldController,
                      autofocus: true,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          labelText: 'Aquarium',
                          hintText: 'New Aquarium'),
                    ),
                    TextButton(
                        child: Text(validateButtonText),
                        onPressed: () {
                          resultName = _textFieldController.text;
                          Navigator.pop(context, "Add");
                        }),
                    TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => {Navigator.pop(context, "Cancel")}),
                  ]),
                )
              ]),
        ) ==
        "Cancel") {
      return "";
    }
    //showAlignedDialog()
    return resultName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: ListView.builder(
          itemCount: _aquarium.length,
          shrinkWrap: true,
          itemBuilder: ((context, index) {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                        shadowColor: Colors.blue,
                        color: Colors.lightBlue,
                        elevation: 2,
                        child: Ink.image(
                          child: InkWell(
                            onLongPress: () => _showAquariumMenu(index),
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AquariumDetailPage(
                                        aquarium: _aquarium[index])),
                              )
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: SizedBox(
                                    height: double.infinity,
                                    width: MediaQuery.of(context).size.width,
                                    child: AutoSizeText(
                                        _aquarium[index].name.substring(
                                            0,
                                            (_aquarium[index].name.length < 15)
                                                ? _aquarium[index].name.length
                                                : 15),
                                        maxLines: 1,
                                        minFontSize: 10,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 35,
                                            textStyle: const TextStyle(
                                              decorationThickness: 1.5,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ))))),
                          ),
                          height: MediaQuery.of(context).size.height / 6,
                          width: MediaQuery.of(context).size.width - 20,
                          image: getAquariumImageForBuild(index).image,
                          fit: BoxFit.fitWidth,
                        ))));
          })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan.shade500,
        onPressed: () => _addAquariumN(),
        tooltip: 'Add Aquarium',
        child: const Icon(Icons.add),
      ),
    );
  }

  getAquariumImageForBuild(int index) {
    if (index < _aquariumPhotos.length) {
      return _aquariumPhotos[index].image;
    }
    return AquariumPhoto(
      aquariumId: -420,
      name: "test",
    ).getImage();
  }
}
