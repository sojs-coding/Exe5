// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_parkwhere/services/location_service.dart';
import '../services/publicCarparks_service.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(1.287953, 103.851784),
    zoom: 14.4746,
  );

  List<Marker> _marker = [];
  List<Marker> _list = [];
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
      _marker.clear();
      _marker.addAll(_list);
      _list.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Maps'),),
      body: Column(
        children: [
          Row(
            children: [
            Expanded(
              child: TextFormField(
                controller: _searchController,
                textCapitalization: TextCapitalization.words,
              ),
            ),
            IconButton(
              onPressed: () async {
                var place = await LocationService().getPlace(_searchController.text);
                List location = await _goToPlace(place);
                _getPublicCarparks(location);
              }, 
              icon: Icon(Icons.search),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: Set<Marker>.of(_marker),
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _onMapCreated(controller);
              },
              
            ),
          ),
        ],
      ),
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
    _list.add( 
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

  Future<void> _getPublicCarparks(List location) async {
    final double lat = location[0];
    final double lng = location[1];

    var response = await PublicCarparksService().getPublicCarparks(lat, lng);
    //print(response.length);
    response.forEach((key, value){
      _list.add( 
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