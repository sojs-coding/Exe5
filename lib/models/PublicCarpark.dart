// ignore: file_names
import 'dart:ffi';

import 'Carpark.dart';

class PublicCarpark extends Carpark {
  late String carparkType;
  late bool electronicParkingSystem;
  late String shortTermParking;
  late String freeParking;
  late bool nightParking;
  late int carparkDeckNumber;
  late Float gantryHeight;
  late bool carparkBasement;

  PublicCarpark();

  PublicCarpark.fromJson(String id,Map<dynamic, dynamic> parsedJson)
      : carparkType = parsedJson['carpark_type'],
        electronicParkingSystem = parsedJson['electronic_parking_system'],
        shortTermParking = parsedJson['short_term_parking'],
        freeParking = parsedJson['free_parking'],
        nightParking = parsedJson['night_parking'],
        carparkDeckNumber = parsedJson['carpark_deck_number'],
        gantryHeight = parsedJson['gantry_height'],
        carparkBasement = parsedJson['carpark_basement'];
}