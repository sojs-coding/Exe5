import 'package:flutter_parkwhere/models/Availability.dart';
import 'package:flutter_parkwhere/models/Carpark.dart';
import 'package:flutter_parkwhere/models/PrivateCarpark.dart';
import 'package:flutter_parkwhere/models/PublicCarpark.dart';

class CarparkFactory {
  Carpark getCarpark(String key, dynamic carparkJson) {
    Carpark carpark;
    if (carparkJson.containsKey('weekday_parking_fare')) {
      carpark = PrivateCarpark.fromJson(key, carparkJson);
    }
    else {
      Availability availability;
      carpark = PublicCarpark.fromJson(key, carparkJson);
      Map<String, dynamic> availabilityJson = (carparkJson['availability'] as Map<String, dynamic>);
      availabilityJson.forEach((timestamp, value) {
        availability = Availability.fromJson(timestamp, value);
        (carpark as PublicCarpark).addAvailability(availability);
      });
    }
    return carpark;
  }
}