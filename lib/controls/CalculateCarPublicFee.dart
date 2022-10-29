import 'package:flutter_parkwhere/interfaces/CalculateFee.dart';
import 'package:flutter_parkwhere/models/Carpark.dart';
import 'package:flutter_parkwhere/models/PublicCarpark.dart';

class CalculateCarPublicFee with CalculateFee{
  @override
  String calculateFee(DateTime start, DateTime end, String vehicleSelected, Carpark carpark) {
    double temp = 0;
    String returnString = "";
    PublicCarpark tempCarpark = carpark as PublicCarpark;
    if(checkOvernightParking(start, end, tempCarpark)){
      if(CalculateFee.centralCarparkNumbers.contains(tempCarpark.carparkId)){
        int interval30minOffPeak = 0;
        int interval30minPeak = 0;
        int interval30minNight = 0;
        int numOfCap = 0;
        while(start.compareTo(end) < 0){
          DateTime tempDateTime = start.add(const Duration(minutes: 30));
          if(start.weekday == DateTime.sunday || (start.hour > 16 || start.hour < 7)){
            if(tempDateTime.weekday == DateTime.sunday || (tempDateTime.hour > 16 || tempDateTime.hour < 7)){
              start = tempDateTime;
            }
            else{
              while(tempDateTime.weekday == DateTime.sunday || (tempDateTime.hour > 16 || tempDateTime.hour < 7)){
                start = start.add(const Duration(minutes: 1));
              }

            }
            interval30minPeak++;
          }
          else{
            if(start.hour == 23 || start.hour < 7 || (start.hour == 22 && start.minute >= 30)){ //within night parking period
              interval30minNight++;
              if(interval30minNight == 9){
                numOfCap++;
                interval30minOffPeak -= 9;
                while(start.hour != 7){
                  start = start.add(const Duration(minutes: 30));
                }
              }
            }
            else{//diff night, reset night interval
              interval30minNight = 0;
            }
            if (!(tempDateTime.weekday == 7 || (tempDateTime.hour > 16 || tempDateTime.hour < 7))) { //current time + 30 outside peak period
              start = tempDateTime;
            }
            else {
              while (!(tempDateTime.weekday == 7 || (tempDateTime.hour > 16 || tempDateTime.hour < 7))) { //current time += 1min until within peak period
                start = start.add(const Duration(minutes: 1));
              }
            }
            interval30minOffPeak++;
          }
        }
        temp = 1.2 * interval30minPeak + 0.6 * interval30minOffPeak + 5 * numOfCap;
      }
      else{
        int interval30minNight = 0;
        int numOfCap = 0;
        int interval30min = 0;
        while (start.compareTo(end) < 0) {
          if(start.hour == 23 || start.hour < 7 || (start.hour == 22 && start.minute >= 30)){ //within night parking period
            interval30minNight++;
            if(interval30minNight == 9){
              numOfCap++;
              interval30min -= 9;
              while(start.hour != 7){
                start = start.add(const Duration(minutes: 30));
              }
            }
          }
          else{//diff night, reset night interval
            interval30minNight = 0;
          }
          start = start.add(const Duration(minutes: 30));
          interval30min++;
        }
        temp = 0.6 * interval30min + 5 * numOfCap;
      }
    }
    else{
      returnString = "NA";
    }
    if(returnString == ""){
      return double.parse(temp.toStringAsFixed(2)).toString();
    }
    return returnString;
  }
}