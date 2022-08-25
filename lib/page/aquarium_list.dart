import 'package:flutter/material.dart';

import '../widget/aquarium_list.dart';
import '../widget/header.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: HeaderWidget(title: "AquaCare", isHome: true)),
      body: AquariumListWidget(),
    );
  }
}
