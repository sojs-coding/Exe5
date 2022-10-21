import 'dart:ffi';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter_parkwhere/models/Carpark.dart';

import '../models/PrivateCarpark.dart';
import '../models/PublicCarpark.dart';

class SortService{
  List<dynamic> sortByDistance(List<dynamic> carparks, List<dynamic>latLng){
    List<dynamic> carparkToReturn = [];
    double lat1 = 0, lng1 = 0, lat2 = 0, lng2 = 0;
    bool added = false;
    for(var item in carparks){
      added = false;
      if(carparkToReturn.isEmpty){
        carparkToReturn.add(item);
      } else{
        if (item is PrivateCarpark) {
          PrivateCarpark carpark = item;
          lat1 = carpark.yCoordWGS84; lng2 = carpark.xCoordWGS84;
        }
        else {
          PublicCarpark carpark = item as PublicCarpark;
          lng1 = carpark.yCoordWGS84; lng2 = carpark.xCoordWGS84;
        }
        for(int i=0; i<carparkToReturn.length; i++){
          if (carparkToReturn[i] is PrivateCarpark) {
            PrivateCarpark carpark = carparkToReturn[i] as PrivateCarpark;
            lat2 = carpark.yCoordWGS84; lng2 = carpark.xCoordWGS84;
          }
          else {
            PublicCarpark carpark = carparkToReturn[i] as PublicCarpark;
            lat2 = carpark.yCoordWGS84; lng2 = carpark.xCoordWGS84;
          }
          if(calculateDistance(latLng[0], latLng[1], lat2, lng2) < calculateDistance(latLng[0], latLng[1],  lat1, lng1)){
            carparkToReturn.insert(i,item);
            added = true;
            break;
          }
        }
        if(!added) {
          carparkToReturn.insert(carparkToReturn.length, item);
        }
      }
    }
    return carparkToReturn;
  }


  List<Carpark> sortByAvailability(List<dynamic> carparks){
    List<Carpark> carparkToReturn = [];
    for(var carpark in carparks){
      int i=0;
      int currentAvailability = 0;
      int listElementAvailability = 0;
      for(; i<carparkToReturn.length; i++){
        if(carpark is Carpark){
          currentAvailability = carpark.getLatestAvailability()?.availableLots ?? 0;
          listElementAvailability = carparkToReturn[i].getLatestAvailability()?.availableLots ?? 0;
          if(currentAvailability > listElementAvailability){
            break;
          }
        }
      }
      carparkToReturn.insert(i, carpark);
    }
    return carparkToReturn;
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
}
//=acos(sin(lat1)*sin(lat2)+cos(lat1)*cos(lat2)*cos(lon2-lon1))*6371