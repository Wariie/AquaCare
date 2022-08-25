import 'package:flutter/material.dart';
import 'package:flutter_app_test0/page/aquarium_list.dart';

void main() {
  runApp(const AquaCare());
}

class AquaCare extends StatelessWidget {
  const AquaCare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaCare v0.0',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        //'/second': (context) => const SecondScreen(),
      },
      theme:
          ThemeData(primarySwatch: Colors.blue, backgroundColor: Colors.white),
    );
  }
}
