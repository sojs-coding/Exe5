// ignore: file_names
import 'dart:ffi';

import 'Carpark.dart';

class PublicCarpark extends Carpark {
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
        super.fromJson(id, parsedJson);

  num getFee(int durationInMinutes)
  {
    int halfAndHourCount = (durationInMinutes / 30).ceil();
    num total = halfAndHourCount * shortTermParkingFare['car'];
    return total;
  }
}