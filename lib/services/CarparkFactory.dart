import 'package:flutter_parkwhere/models/Carpark.dart';
import 'package:flutter_parkwhere/models/PrivateCarpark.dart';
import 'package:flutter_parkwhere/models/PublicCarpark.dart';

class CarparkFactory {
  Carpark getCarpark(String key, dynamic carparkJson) {
      if (carparkJson.containsKey('weekday_parking_fare')) {
        return PrivateCarpark.fromJson(key, carparkJson);
      }
      else {
        return PublicCarpark.fromJson(key, carparkJson);
      }
  }
}