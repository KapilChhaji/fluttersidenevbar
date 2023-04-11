import 'package:alieample2/splash.dart';
import 'package:flutter/material.dart';

import 'MyStatefulWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  static const String _title = 'Sample App';

  //static bool  loginuser=false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
          // appBar: AppBar(title: const Text(_title)),
          body:
              //loginuser==false?
          Splash()
          //Welcome(title: "")
          ),
    );
  }
}
