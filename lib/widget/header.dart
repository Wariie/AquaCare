import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderWidget extends StatefulWidget {
  final String title;
  final bool isHome;

  const HeaderWidget({Key? key, required this.title, this.isHome = false})
      : super(key: key);

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late bool isHome = false;
  late String title;

  String defaultTitle = "AquaCare";

  @override
  void initState() {
    title = widget.title;
    isHome = widget.isHome;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget backButtonBackground = const Icon(
      Icons.arrow_back_sharp,
      color: Colors.white,
    );
    if (isHome) {
      backButtonBackground = SizedBox(
          child: Image.file(
              File(
                  "C:\\Users\\guilh\\Desktop\\Dev\\Projets Dart\\flutter_app_test0\\assets\\5389232.png"),
              fit: BoxFit.scaleDown));
    }

    return Container(
        decoration: BoxDecoration(color: Colors.blue.shade800),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: MaterialButton(
                    height: double.infinity,
                    onPressed: () => {if (!isHome) Navigator.pop(context)},
                    child: backButtonBackground,
                    //hoverColor: Colors.white54,
                    splashColor: Colors.white,
                  )),
              Expanded(
                  flex: 4,
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                          child: AutoSizeText(
                              (title != "") ? title : defaultTitle,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              //minFontSize: 20,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  textStyle: const TextStyle(fontSize: 80)))))),
              Expanded(
                  flex: 1,
                  child: MaterialButton(
                    height: double.infinity,
                    onPressed: () =>
                        {}, //TODO IMPLEMENTS MENU FUNCTION ARGUMENT
                    child: const Icon(
                      Icons.menu_sharp,
                      color: Colors.white,
                    ),
                    //hoverColor: Colors.white54,
                    splashColor: Colors.white,
                  )),
            ]));
  }
}
