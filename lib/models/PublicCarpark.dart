// ignore: file_names
import 'dart:ffi';

import 'package:flutter_parkwhere/interfaces/IsMappable.dart';
import 'package:flutter_parkwhere/models/Availability.dart';

import 'Carpark.dart';

class PublicCarpark extends Carpark implements IsMappable {
  late final String carparkType;
  late final bool electronicParkingSystem;
  late final String shortTermParking;
  // Types of Vehicles: 'car', 'motorbike', 'heavy'
  // Mapped into it's individual cost for the Carpark
  late final Map<String, dynamic> shortTermParkingFare;
  late final String freeParking;
  late final bool nightParking;
  late final int carparkDeckNumber;
  late final double gantryHeight;
  late final bool carparkBasement;
  late final int? totalLots;

  final List<Availability> availabilityList = [];

  PublicCarpark();

  PublicCarpark.fromJson(String id,Map<dynamic, dynamic> parsedJson)
      : carparkType = parsedJson['carpark_type'],
        electronicParkingSystem = parsedJson['electronic_parking_system'],
        shortTermParking = parsedJson['short_term_parking'],
        shortTermParkingFare = parsedJson['short_term_parking_fare'],
        freeParking = parsedJson['free_parking'],
        nightParking = parsedJson['night_parking'],
        carparkDeckNumber = parsedJson['carpark_deck_number'],
        gantryHeight = parsedJson['gantry_height'],
        carparkBasement = parsedJson['carpark_basement'],
        totalLots = parsedJson['total_lots'],
        super.fromJson(id, parsedJson);

  void addAvailability(Availability availability) {
    availabilityList.insert(0, availability);
  }

  // Prevents carpark _availability list from being modified
  List<Availability> getAvailability() {
    return [...availabilityList];
  }

  // Returns the latest availability
  Availability? getLatestAvailability() {
    try {
      return availabilityList.first;
    }
    catch (e) {
      return null;
    }
  }

  void clearAvailability() {
    availabilityList.clear();
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map.addAll(super.toMap());
    map.addAll({
      "carparkType" : carparkType,
      "electronicParkingSystem" : electronicParkingSystem,
      "shortTermParking" : shortTermParking,
      "shortTermParkingFare" : shortTermParkingFare,
      "freeParking" : freeParking,
      "nightParking" : nightParking,
      "carparkDeckNumber" : carparkDeckNumber,
      "gantryHeight" : gantryHeight,
      "carparkBasement" : carparkBasement,
      "totalLots" : totalLots
    });
    return map;
  }
}