import 'package:flutter_parkwhere/interfaces/CalculateFee.dart';
import 'package:flutter_parkwhere/models/Carpark.dart';
import 'package:flutter_parkwhere/models/PrivateCarpark.dart';

class CalculatePrivateFee with CalculateFee{
  @override
  double calculateFee(DateTime start, DateTime end, String vehicleSelected, Carpark carpark) {
    double temp = 0;
    PrivateCarpark tempCarpark = carpark as PrivateCarpark;
    if(start.compareTo(end) < 0){
      if(start.weekday != DateTime.sunday && start.weekday != DateTime.saturday){
        temp += tempCarpark.weekdayEntryFare;
      }
      else{
        temp += tempCarpark.weekendEntryFare;
      }
    }
    while(start.compareTo(end) < 0){
      DateTime tempDate = DateTime(start.year,start.month,start.day);
      if(start.weekday == 7 || CalculateFee.publicHoliday.contains(tempDate)){ //if weekend//public holiday
        temp += tempCarpark.sundayPhParkingFare;
      }
      else if(start.weekday == 6){  //if sat
        temp += tempCarpark.saturdayParkingFare;
      }
      else{ //if weekday
        temp += tempCarpark.weekdayParkingFare;
      }
      start = start.add(const Duration(minutes: 30));
    }
    return temp;
  }
}