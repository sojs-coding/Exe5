// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_parkwhere/models/Carpark.dart';
import 'package:flutter_parkwhere/services/AllCarparksService.dart';
import 'package:flutter_parkwhere/factories/CarparkFactory.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_parkwhere/services/LocationService.dart';
import 'package:flutter_parkwhere/screens/Map.dart';

class MapScreen extends StatefulWidget {

  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {

  @override
  Widget build(BuildContext context) => MapScreenView(this);

  static final CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(1.287953, 103.851784),
    zoom: 14.4746,
  );

  late List<Carpark> nearest5Carparks = [];
  late List<double> location = [];
  List<Marker> markers = [];
  late String _mapStyle;

  late GoogleMapController _mapController;
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController searchController = TextEditingController();

  @override
  initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  onMapCreated(GoogleMapController controller) {
    if (mounted) {
      setState(() {
        _mapController = controller;
        controller.setMapStyle(_mapStyle);
        _controller.complete(controller);
      });
    }
  }

  searchAllCarparksNearDestination() async {
    var place = await LocationService().getPlace(searchController.text);
    location = await _goToPlace(place);
    _getAllCarparks(location);
  }

  void _setMarker() {
    setState(() {});
  }

  Future<List<double>> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 17),
      ),
    );
    markers.add(
      Marker(
          markerId: MarkerId('1'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
              title: 'Destination'
          )
      ),
    );
    //_setMarker(LatLng(lat, lng));
    return [lat, lng];
  }

  Future<void> _getAllCarparks(List location) async {
    final double lat = location[0];
    final double lng = location[1];

    nearest5Carparks.clear();
    var response = await AllCarparksService().getCarparks(lat, lng);
    CarparkFactory carparkFactory = CarparkFactory();

    //print(response.length);
    response.forEach((key, value){
      markers.add(
        Marker(
            markerId: MarkerId(key),
            position: LatLng(value['x_coord_WGS84'], value['y_coord_WGS84']),
            infoWindow: InfoWindow(
              title: value['address'],
            )
        ),
      );
      nearest5Carparks.add(carparkFactory.getCarpark(key, value));
      });
    _setMarker();
  }
}