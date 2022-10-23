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

class MarkerPlaceholder {

}

class MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) => MapScreenView(this);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(1.287953, 103.851784),
    zoom: 14.4746,
  );

  static CameraPosition getkGooglePlex() => _kGooglePlex;

  LatLng _cameraLatLng = _kGooglePlex.target;
  double _cameraZoom = _kGooglePlex.zoom;
  bool searched = false;

  late List<Carpark> _nearest5Carparks = [];

  List<Carpark> getNearest5Carparks() {
    return _nearest5Carparks;
  }

  LatLng _location = LatLng(1.287953, 103.851784);

  void setLocation(double latitude, double longitude) {
    if (latitude >= -85 && latitude <= 85.05115 && longitude >= -180 && longitude <= 180) {
      _location = LatLng(latitude, longitude);
    }
  }

  LatLng getLocation() {
    return _location;
  }

  List<Marker> _markers = [];

  List<Marker> getMarkers() {
    return _markers;
  }

  late String _mapStyle;

  late GoogleMapController _mapController;
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();

  getSearchController() {
    return _searchController;
  }

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

  onCameraMove(CameraPosition cameraPosition) {
    _cameraLatLng = cameraPosition.target;
    _cameraZoom = cameraPosition.zoom;
  }

  onCameraIdle() {
    // Panning
    if (_searchController.text == "") {
      // If there's no search input and zoom above
      if (_cameraZoom >= 16) {
        _location = LatLng(_cameraLatLng.latitude, _cameraLatLng.longitude);
        _nearest5Carparks.clear();
        _markers.clear();
        Marker marker =
        Marker(
            markerId: MarkerId('1'),
            position: LatLng(_location.latitude + 0.00008, _location.longitude),
            infoWindow: InfoWindow(title: 'Destination'),
            icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );
        _markers.add(marker);
        _getAllCarparks(_location);
      }
    }
  }

  searchAllCarparksNearDestination() async {
    if(searched == false) {
      searched = true;
      var place = await LocationService().getPlace(_searchController.text);
      _location = await _goToPlace(place);
      await _getAllCarparks(_location);
      searched = false;
    }
  }

  void _setMarker() {
    setState(() {});
  }

  Future<LatLng> _goToPlace(Map<String, dynamic> place) async {
    LatLng latlng = LatLng(place['geometry']['location']['lat'], place['geometry']['location']['lng']);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latlng, zoom: 17),
      ),
    );
    _nearest5Carparks.clear();
    _markers.clear();
    _markers.add(
      Marker(
          markerId: MarkerId('1'),
          position: LatLng(latlng.latitude + 0.00008, latlng.longitude),
          infoWindow: InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
      ),
    );
    //_setMarker(LatLng(lat, lng));
    return latlng;
  }

  Future<void> _getAllCarparks(LatLng location) async {
    final double lat = location.latitude;
    final double lng = location.longitude;

    var response = await AllCarparksService().getCarparks(lat, lng, 5);
    CarparkFactory carparkFactory = CarparkFactory();

    //print(response.length);
    response.forEach((key, value) {
      _markers.add(
        Marker(
            markerId: MarkerId(key),
            position: LatLng(value['x_coord_WGS84'], value['y_coord_WGS84']),
            infoWindow: InfoWindow(
              title: value['address'],
            ),
            consumeTapEvents: true
        ),
      );
      _nearest5Carparks.add(carparkFactory.getCarpark(key, value));
    });
    _setMarker();
  }
}
