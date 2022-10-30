import 'package:flutter_parkwhere/interfaces/CalculateFee.dart';
import 'package:flutter_parkwhere/models/Carpark.dart';
import 'package:flutter_parkwhere/models/PublicCarpark.dart';

class CalculateHeavyPublicFee with CalculateFee{
  @override
  double calculateFee(DateTime start, DateTime end, String vehicleSelected, Carpark carpark) {
    double temp = 0;
    PublicCarpark tempCarpark = carpark as PublicCarpark;
    if(checkOvernightParking(start, end, tempCarpark)){
      int interval30Min = 0;
      while(start.compareTo(end) < 0){
        start = start.add(const Duration(minutes: 30));
        interval30Min++;
      }
      temp = interval30Min * 1.2;
    }
    else{
      temp = -1;
    }
    return temp;
  }
}