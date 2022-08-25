import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test0/database/database.dart';
import 'package:flutter_app_test0/database/object/aquarium_photo.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class AquariumPhotoWidget extends StatefulWidget {
  final int aquariumId;

  const AquariumPhotoWidget({Key? key, required this.aquariumId})
      : super(key: key);

  @override
  _AquariumPhotoWidgetState createState() => _AquariumPhotoWidgetState();
}

class _AquariumPhotoWidgetState extends State<AquariumPhotoWidget> {
  late int aquariumId;

  Future<List<AquariumPhoto>>? photos;

  AquariumDatabase aquariumDatabase = AquariumDatabase();

  @override
  void initState() {
    super.initState();
    aquariumId = widget.aquariumId;
    aquariumDatabase.open();
    _fetchAquariumPhotos(aquariumId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Container(
          color: Colors.blue,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("  x/x"),
            const Text(
              "Photos",
              textAlign: TextAlign.start,
            ),
            IconButton(
                alignment: Alignment.centerRight,
                hoverColor: Colors.white,
                onPressed: (() => {}),
                icon: const Icon(Icons.edit))
          ])),
      FutureBuilder(
          future: photos,
          initialData: const <AquariumPhoto>[],
          builder: (BuildContext context,
              AsyncSnapshot<List<AquariumPhoto>?> snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container();
            }
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Material(
                              clipBehavior: Clip.hardEdge,
                              shadowColor: Colors.blue,
                              color: Colors.lightBlue,
                              elevation: 2,
                              child: Ink.image(
                                child: InkWell(
                                  child: Padding(
                                      padding: const EdgeInsets.all(32.0),
                                      child: SizedBox(
                                          height: double.infinity,
                                          child: AutoSizeText(
                                              (index + 1).toString() +
                                                  "/" +
                                                  snapshot.data!.length
                                                      .toString(),
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
                                image: snapshot.data![index].image!.image,
                                fit: BoxFit.fitWidth,
                              )));
                    })));
          })
    ]);
  }

  Future _fetchAquariumPhotos(int aquariumId) async {
    List<AquariumPhoto> list = <AquariumPhoto>[];
    var dbList = await aquariumDatabase
        .listWhere(AquariumPhoto.tableName, aquariumId, column: "aquariumId");
    for (var e in dbList) {
      list.add(AquariumPhoto.fromMap(e));
    }

    for (var photo in list) {
      photo.getImage();
    }

    setState(() {
      photos = Future.value(list);
    });
  }

  _showPhotosMenu(int index) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              alignment: Alignment.bottomCenter,
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Photos",
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
                            Navigator.pop(context, 'Edit');
                          },
                          child: const Text('Edit'),
                        ),
                        TextButton(
                          onPressed: () async {
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
}
