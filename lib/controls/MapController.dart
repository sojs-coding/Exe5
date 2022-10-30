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
import '../services/PublicCarparksService.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) => MapScreenView(this);

  static final CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(1.304833, 103.831833),
    zoom: 16,
  );

  LatLng _cameraLatLng = kGooglePlex.target;
  double _cameraZoom = kGooglePlex.zoom;
  bool _searched = false;
  bool _markerPressed = false;
  bool _searchingForCarparks = false;

  late final List<Carpark> nearest5Carparks = [];

  final List<Widget> searchOption = <Widget>[Text('Destination'), Text('Carpark ID')];

  final List<bool> selectedSearchOption = <bool>[true, false];

  final bool vertical = false;

  LatLng location = LatLng(1.287953, 103.851784);

  final List<Marker> markers = [];

  late String _mapStyle;

  late GoogleMapController _mapController;
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController searchController = TextEditingController();

  late BitmapDescriptor myIcon;

  double _pinPillPosition = -200;

  double get pinPillPosition => _pinPillPosition;
  int _currentCarparkPin = 0;

  int get currentCarparkPin => _currentCarparkPin;

  @override
  initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(28, 28)), 'assets/carpark_marker.png')
          .then((onValue) {
        myIcon = onValue;
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
    if (searchController.text == "") {
      // If there's no search input and zoom above
      if (_cameraZoom >= 16) {
        _searchingForCarparks = true;
        location = LatLng(_cameraLatLng.latitude, _cameraLatLng.longitude);

        nearest5Carparks.clear();
        markers.clear();

        nearest5Carparks.addAll(await _getAllCarparks(location));
        for (Carpark carpark in nearest5Carparks) {
          Marker marker = _getCarparkMarker(carpark);
          markers.add(
              _getPanningCarparkMarker(carpark)
          );
        }
        setState(() {
          markers.add(
              _getDestinationMarker(location)
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
      var place = await LocationService().getPlace(searchController.text);
      if(place.isEmpty) {
        _searched = false;
        _searchingForCarparks = false;
        searchController.clear();
        return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Invalid Destination'),
              content: const Text('No such place exist in the\n'
                                  'world.'),
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

      location = await _getCoordinateOfPlace(place);

      nearest5Carparks.clear();
      markers.clear();

      nearest5Carparks.addAll(await _getAllCarparks(location));
      for (Carpark carpark in nearest5Carparks) {
        markers.add(
          _getCarparkMarker(carpark)
        );
      }
      setState(() {
        markers.add(
            _getDestinationMarker(location)
        );
      });
      await _panToCoordinate(location);
      _searched = false;
      _searchingForCarparks = false;
    }
  }

  searchCarparkID() async {
    if (_searchingForCarparks) {
      return;
    }

    if(_searched == false) {
      _searched = true;
      _searchingForCarparks = true;
      
      markers.clear();
      nearest5Carparks.clear();

      nearest5Carparks.addAll(await _searchByCarparkID(searchController.text.toUpperCase()));
      if(nearest5Carparks.isNotEmpty) {
        _currentCarparkPin = 0;
        for (Carpark carpark in nearest5Carparks) {
          setState(() {
            markers.add(
              _getCarparkMarker(carpark)
            );
        });
        }
        await _panToCoordinate(location);
        _searched = false;
        _searchingForCarparks = false;
      }
      else {
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
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    return marker;
  }

  Marker _getCarparkMarker(Carpark carpark) {
    return Marker(
      markerId: MarkerId(carpark.carparkId),
      position: LatLng(carpark.xCoordWGS84, carpark.yCoordWGS84),

      onTap: () {
        setState(() {
          _currentCarparkPin = nearest5Carparks.indexWhere((nearest5Carparks) => nearest5Carparks.carparkId == carpark.carparkId);
          _pinPillPosition = 0;
        });
      },
      icon: myIcon
    );
  }

  Marker _getPanningCarparkMarker(Carpark carpark) {
    return Marker(
      markerId: MarkerId(carpark.carparkId),
      position: LatLng(carpark.xCoordWGS84, carpark.yCoordWGS84),
      onTap: () {
        _markerPressed = true;
        setState(() {
          _currentCarparkPin = nearest5Carparks.indexWhere((nearest5Carparks) => nearest5Carparks.carparkId == carpark.carparkId);
          _pinPillPosition = 0;
        });
      },
      icon: myIcon
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
    var response = await PublicCarparksService().getCarparkByID(carparkID);
    CarparkFactory carparkFactory = CarparkFactory();

    List<Carpark> listOfCarparks = [];

    //print(response.length);
    response.forEach((key, value) {
      listOfCarparks.add(carparkFactory.getCarpark(key, value));
    });
    return listOfCarparks;
  }

  dismissPinPill() async {
    setState(() {
      _pinPillPosition = -200;
    });
  }
}