import 'dart:ffi';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter_parkwhere/models/Carpark.dart';
import 'package:flutter_parkwhere/models/PrivateCarpark.dart';
import 'package:flutter_parkwhere/models/PublicCarpark.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SortService {
  List<Carpark> sortByDistance(List<Carpark> carparks, LatLng latlng) {
    List<Carpark> carparkToReturn = [];
    double lat1 = 0, lng1 = 0, lat2 = 0, lng2 = 0;
    bool added = false;
    for (var item in carparks) {
      added = false;
      if (carparkToReturn.isEmpty) {
        carparkToReturn.add(item);
      } else {
        lat1 = item.yCoordWGS84;
        lng1 = item.xCoordWGS84;
        for (int i = 0; i < carparkToReturn.length; i++) {
          lat2 = carparkToReturn[i].yCoordWGS84;
          lng2 = carparkToReturn[i].xCoordWGS84;
          if (calculateDistance(latlng.longitude, latlng.latitude, lat2, lng2) >
              calculateDistance(
                  latlng.longitude, latlng.latitude, lat1, lng1)) {
            carparkToReturn.insert(i, item);
            added = true;
            break;
          }
        }
        if (!added) {
          carparkToReturn.insert(carparkToReturn.length, item);
        }
      }
    }
    return carparkToReturn;
  }

  List<Carpark> sortByAvailability(List<Carpark> carparks) {
    List<Carpark> carparkToReturn = [];
    List<Carpark> privateCarpark = [];

    void swap(int i, int j) {
      Carpark temp = carparkToReturn[i];
      carparkToReturn[i] = carparkToReturn[j];
      carparkToReturn[j] = temp;
    }

    for (var carpark in carparks) {
      int currentAvailability = 0;
      int listElementAvailability = 0;
      if (carpark is PublicCarpark)
      {
        carparkToReturn.add(carpark);
        currentAvailability = carpark.getLatestAvailability()?.availableLots ?? 0;
        int j = carparkToReturn.length-1;
        for (int i = carparkToReturn.length-2; i >= 0; i--) {
          listElementAvailability = (carparkToReturn[i] as PublicCarpark).getLatestAvailability()?.availableLots ?? 0;
          if (currentAvailability > listElementAvailability) {
            swap(i, j--);
          }
        }
      }
      else {
        privateCarpark.add(carpark);
      }
    }
    carparkToReturn.addAll(privateCarpark);
    return carparkToReturn;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
//=acos(sin(lat1)*sin(lat2)+cos(lat1)*cos(lat2)*cos(lon2-lon1))*6371