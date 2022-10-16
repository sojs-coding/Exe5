import 'dart:ffi';

import 'package:flutter_parkwhere/models/Availability.dart';

abstract class Carpark {
  late final String carparkId;
  late final String address;
  late final double xCoordWGS84;
  late final double yCoordWGS84;
  final List<Availability> _availability = [];

  Carpark();

  Carpark.fromJson(String id,Map<dynamic, dynamic> parsedJson)
      : carparkId = id,
        address = parsedJson['address'],
        xCoordWGS84 = parsedJson['x_coord_WGS84'],
        yCoordWGS84 = parsedJson['y_coord_WGS84'];

  void addAvailability(Availability availability) {
    _availability.add(availability);
  }

  // Prevents carpark _availability list from being modified
  List<Availability> getAvailability() {
    return [..._availability];
  }

  // Returns the latest availability
  Availability? getLatestAvailability() {
    try {
      return _availability.last;
    }
    catch (e) {
      return null;
    }
  }

  void clearAvailability() {
    _availability.clear();
  }
}