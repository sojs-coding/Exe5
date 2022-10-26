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
import '../services/SearchCarparkId.dart';

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
  bool _searched = false;
  bool _markerPressed = false;
  bool _searchingForCarparks = false;

  late List<Carpark> _nearest5Carparks = [];

  //Search by Carpark ID
  final List<Widget> searchOption = <Widget>[Text('Destination'), Text('Carpark ID')];
  List<bool> selectedSearchOption = <bool>[true, false];
  bool vertical = false;

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

  final List<Marker> _markers = [];

  List<Marker> getMarkers() {
    return _markers;
  }

  late String _mapStyle;

  late GoogleMapController _mapController;
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();

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

  onCameraIdle() async {
    if (_markerPressed) {
      _markerPressed = false;
      return;
    }

    if (_searchingForCarparks) {
      return;
    }

    // Panning
    if (_searchController.text == "") {
      // If there's no search input and zoom above
      if (_cameraZoom >= 16) {
        _searchingForCarparks = true;
        _location = LatLng(_cameraLatLng.latitude, _cameraLatLng.longitude);

        _nearest5Carparks.clear();
        _markers.clear();

        _nearest5Carparks = await _getAllCarparks(_location);
        for (Carpark carpark in _nearest5Carparks) {
          Marker marker = _getCarparkMarker(carpark);
          _markers.add(
              _getPanningCarparkMarker(carpark)
          );
        }
        setState(() {
          _markers.add(
              _getDestinationMarker(_location)
          );
        });
        _searchingForCarparks = false;
      }
    }
  }

  searchAllCarparksNearDestination() async {
    if (_searchingForCarparks) {
      return;
    }

    if(_searched == false) {
      _searched = true;
      _searchingForCarparks = true;
      var place = await LocationService().getPlace(_searchController.text);
      _location = await _getCoordinateOfPlace(place);

      _nearest5Carparks.clear();
      _markers.clear();

      _nearest5Carparks = await _getAllCarparks(_location);
      for (Carpark carpark in _nearest5Carparks) {
        _markers.add(
          _getCarparkMarker(carpark)
        );
      }
      setState(() {
        _markers.add(
            _getDestinationMarker(_location)
        );
      });
      await _panToCoordinate(_location);
      _searched = false;
      _searchingForCarparks = false;
    }
  }

  searchCarparkID(BuildContext context) async {
    if (_searchingForCarparks) {
      return;
    }

    if(_searched == false) {
      _searched = true;
      _searchingForCarparks = true;
      
      _markers.clear();
      _nearest5Carparks.clear();

      _nearest5Carparks = await _searchByCarparkID(_searchController.text.toUpperCase());
      if(_nearest5Carparks.isNotEmpty) {
        for (Carpark carpark in _nearest5Carparks) {
          _location = LatLng(carpark.xCoordWGS84, carpark.yCoordWGS84);
          setState(() {
            _markers.add(
              _getCarparkMarker(carpark)
            );
        });
        }
        await _panToCoordinate(_location);
        _searched = false;
        _searchingForCarparks = false;
      }
      else {
        setState(() {});
        _searched = false;
        _searchingForCarparks = false;
        return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Invalid Carpark ID'),
              content: const Text('No carpark with that ID\n'
                                  'exist.'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<LatLng> _getCoordinateOfPlace(Map<String, dynamic> place) async {
    return LatLng(place['geometry']['location']['lat'], place['geometry']['location']['lng']);
  }

  Future<void> _panToCoordinate(LatLng latlng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latlng, zoom: 17),
      ),
    );
  }

  Future<List<Carpark>> _getAllCarparks(LatLng location) async {
    final double lat = location.latitude;
    final double lng = location.longitude;

    var response = await AllCarparksService().getCarparks(lat, lng, 5);
    CarparkFactory carparkFactory = CarparkFactory();

    List<Carpark> listOfCarparks = [];

    //print(response.length);
    response.forEach((key, value) {
      listOfCarparks.add(carparkFactory.getCarpark(key, value));
    });
    return listOfCarparks;
  }

  Marker _getDestinationMarker(LatLng latlng) {
    Marker marker = Marker(
      markerId: MarkerId('1'),
      position: LatLng(latlng.latitude + 0.00008, latlng.longitude),
      infoWindow: InfoWindow(title: 'Destination'),
      icon:
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    return marker;
  }

  Marker _getCarparkMarker(Carpark carpark) {
    return Marker(
      markerId: MarkerId(carpark.carparkId),
      position: LatLng(carpark.xCoordWGS84, carpark.yCoordWGS84),
      infoWindow: InfoWindow(
        title: carpark.address,
      ),
    );
  }

  Marker _getPanningCarparkMarker(Carpark carpark) {
    return Marker(
      markerId: MarkerId(carpark.carparkId),
      position: LatLng(carpark.xCoordWGS84, carpark.yCoordWGS84),
      infoWindow: InfoWindow(
        title: carpark.address,
      ),
      onTap: () {_markerPressed = true;}
    );
  }

  void searchOptionSelection(int index) {
    setState(() {
      for (int i = 0; i < selectedSearchOption.length; i++) {
        selectedSearchOption[i] = i == index;
      }
    });
  }

  Future<List<Carpark>> _searchByCarparkID(String carparkID) async {
    var response = await SearchCarparkID().getCarpark(carparkID);
    CarparkFactory carparkFactory = CarparkFactory();

    List<Carpark> listOfCarparks = [];

    //print(response.length);
    response.forEach((key, value) {
      listOfCarparks.add(carparkFactory.getCarpark(key, value));
    });
    return listOfCarparks;
  }
}