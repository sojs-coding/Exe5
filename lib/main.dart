import 'package:flutter/material.dart';
import 'package:flutter_parkwhere/screens/Map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkWhere',
      home: MapScreen(),
    );
  }
}

//API in IOS AppDelegate, AndriodManifest, location_service