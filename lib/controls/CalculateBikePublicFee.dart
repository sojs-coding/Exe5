import 'package:flutter_parkwhere/interfaces/CalculateFee.dart';
import 'package:flutter_parkwhere/models/Carpark.dart';
import 'package:flutter_parkwhere/models/PublicCarpark.dart';

class CalculateBikePublicFee with CalculateFee{
  @override
  double calculateFee(DateTime start, DateTime end, String vehicleSelected, Carpark carpark) {
    double temp = 0;
    PublicCarpark tempCarpark = carpark as PublicCarpark;
    if(checkOvernightParking(start, end, tempCarpark)) {//check if start - end within day time
      int interval = 0;
      while(start.compareTo(end) < 0){
        if(start.hour >= 7 && start.hour <= 21 || (start.hour==22 && start.minute <= 30)) { //if morning period
          start = DateTime(start.year, start.month, start.day, 22, 31);
        }
        else{
          start = DateTime(start.year, start.month, start.day, 23, 59);
          start = start.add(const Duration(minutes: 421));
        }
        interval++;
      }
      temp = 0.65 * interval;
    }
    else{
      temp = -1;
    }
    return temp;
  }
}