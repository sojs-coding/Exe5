import 'package:flutter_parkwhere/models/Availability.dart';
import 'package:flutter_parkwhere/models/Carpark.dart';
import 'package:flutter_parkwhere/models/PrivateCarpark.dart';
import 'package:flutter_parkwhere/models/PublicCarpark.dart';

class CarparkFactory {
  Carpark getCarpark(String key, dynamic carparkJson) {
    Carpark carpark;
    Availability availability;
    if (carparkJson.containsKey('weekday_parking_fare')) {
      carpark = PrivateCarpark.fromJson(key, carparkJson);
    }
    else {
      carpark = PublicCarpark.fromJson(key, carparkJson);
    }
    availability = Availability.fromJson(key, carparkJson);
    if (availability.availableLots != null) {
      carpark.addAvailability(availability);
    }
    return carpark;
  }
}