// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_parkwhere/services/AllCarparksService.dart';
import 'package:flutter_parkwhere/services/PrivateCarparksService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_parkwhere/services/LocationService.dart';
import '../models/PublicCarpark.dart';
import '../services/PublicCarparksService.dart';
import 'Sort.dart';
import 'bottomListSheet.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(1.287953, 103.851784),
    zoom: 14.4746,
  );

  
  late List<dynamic> _nearest5Carparks = [];
  List<Marker> _nearest5markers = [];
  List<Marker> _markers = [];
  late String _mapStyle;

  late GoogleMapController _mapController;
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();

  initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  _onMapCreated(GoogleMapController controller) {
    if (mounted) {
      setState(() {
        _mapController = controller;
        controller.setMapStyle(_mapStyle);
         _controller.complete(controller);
      });
    }
  }

  void _setMarker() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: null,
        body: Stack(
        children: <Widget> [
          Row(
            children: [
              Expanded(
                child: GoogleMap(
                  mapToolbarEnabled: false,
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(_markers),
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _onMapCreated(controller);
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: 40 ,
            right: 15,
            left: 15,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20)
                ),
              ),
              child: Row(
                children: <Widget> [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Search..."),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: () async {
                        var place = await LocationService().getPlace(_searchController.text);
                        List location = await _goToPlace(place);
                        _nearest5Carparks = location;
                        _getCarparks(location);
                      }, 
                      icon: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 105,
            right: 5,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
              ),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    SortScreen(carparksToSortLatLng: _nearest5Carparks)));
              },
             child: Icon(Icons.all_inbox_sharp),
            ),
          ),
        ],
      ),),
    );
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
    _markers.add(
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

  Future<void> _getCarparks(List location) async {
    final double lat = location[0];
    final double lng = location[1];

    var response = await AllCarparksService().getCarparks(lat, lng);
    //print(response.length);
    response.forEach((key, value){
      _markers.add(
      Marker(
        markerId: MarkerId(key),
        position: LatLng(value['x_coord_WGS84'], value['y_coord_WGS84']),
        infoWindow: InfoWindow(
          title: value['address'],
        )
      ),
    );
    });
    _setMarker();
  }
}