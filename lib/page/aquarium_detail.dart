import 'package:flutter/material.dart';
import 'package:flutter_app_test0/database/object/aquarium_detail.dart';
import 'package:flutter_app_test0/database/object/care.dart';
import 'package:flutter_app_test0/widget/detail.dart';

import '../database/database.dart';
import '../database/object/aquarium.dart';
import '../widget/aquarium_photo.dart';
import '../widget/header.dart';
import '../widget/measure.dart';

class AquariumDetailPage extends StatefulWidget {
  const AquariumDetailPage({Key? key, required this.aquarium})
      : super(key: key);

  final Aquarium aquarium;

  @override
  State<AquariumDetailPage> createState() => _AquariumDetailPageState();
}

class _AquariumDetailPageState extends State<AquariumDetailPage> {
  final AquariumDatabase aquariumDatabase = AquariumDatabase();

  late Aquarium aquarium;
  late AquariumDetail detail;

  @override
  void initState() {
    super.initState();
    aquarium = widget.aquarium;
    aquariumDatabase.open();
  }

  @override
  Widget build(BuildContext context) {
    Future<AquariumDetail> _detail = getAquariumDetail(aquarium.id);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: HeaderWidget(title: aquarium.name)),
        body: FutureBuilder(
            future: _detail,
            initialData: AquariumDetail(id: -1, aquariumId: aquarium.id),
            builder:
                (BuildContext context, AsyncSnapshot<AquariumDetail> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AquariumDetailWidget(
                        title: aquarium.name,
                        detail: snapshot.data as AquariumDetail),
                    Center(child: MeasureWidget(aquariumId: aquarium.id)),
                    AquariumPhotoWidget(aquariumId: aquarium.id)
                  ],
                );
              } else {
                return const Text("Loading ...");
              }
            }));
  }

  Future<AquariumDetail> getAquariumDetail(int aquariumId) async {
    var result = await aquariumDatabase.where(
        AquariumDetail.typeName, "aquariumId == " + aquariumId.toString());
    var _detail = AquariumDetail.fromMap(result);
    detail = _detail;
    return _detail;
  }
}
