// ignore: file_names
import 'dart:ffi';

import 'Carpark.dart';

class PublicCarpark extends Carpark {
  late final String carparkType;
  late final bool electronicParkingSystem;
  late final String shortTermParking;
  late final String freeParking;
  late final bool nightParking;
  late final int carparkDeckNumber;
  late final Float gantryHeight;
  late final bool carparkBasement;

  PublicCarpark();

  PublicCarpark.fromJson(String id,Map<dynamic, dynamic> parsedJson)
      : carparkType = parsedJson['carpark_type'],
        electronicParkingSystem = parsedJson['electronic_parking_system'],
        shortTermParking = parsedJson['short_term_parking'],
        freeParking = parsedJson['free_parking'],
        nightParking = parsedJson['night_parking'],
        carparkDeckNumber = parsedJson['carpark_deck_number'],
        gantryHeight = parsedJson['gantry_height'],
        carparkBasement = parsedJson['carpark_basement'],
        super.fromJson(id, parsedJson);
}