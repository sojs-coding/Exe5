import 'package:flutter_parkwhere/models/PrivateCarpark.dart';
import 'package:flutter_parkwhere/models/PublicCarpark.dart';
import '../models/Carpark.dart';

final List<String> _centralCarparkNumbers = ['ACB', 'BBB', 'BRB1', 'CY', 'DUXM', 'HLM', 'KAB', 'KAM', 'KAS', 'PRM', 'SLS', 'SR1', 'SR2',
  'TPM', 'UCS', 'WCB'];
final List<DateTime> _publicHoliday = [DateTime(2023,1,1), DateTime(2023,1,22), DateTime(2023,1,23), DateTime(2023,4,7), DateTime(2023,4,22),
  DateTime(2023,5,1), DateTime(2023,6,2), DateTime(2023,6,29), DateTime(2023,8,9), DateTime(2023,11,23), DateTime(2023,12,25),
  DateTime(2022,1,1), DateTime(2022,2,1), DateTime(2022,2,2), DateTime(2022,4,15), DateTime(2022,5,1), DateTime(2022,5,2), DateTime(2022,5,3),
  DateTime(2022,5,15), DateTime(2022,5,16), DateTime(2022,7,10), DateTime(2022,7,11), DateTime(2022,8,9), DateTime(2022,10,24),
  DateTime(2022,12,25), DateTime(2022,12,26)];

abstract class CalculateFee {
  String calculateFee(DateTime start, DateTime end, String vehicleSelected, Carpark carpark);
}

class CalculateCarPublicFee implements CalculateFee{
  @override
  String calculateFee(DateTime start, DateTime end, String vehicleSelected, Carpark carpark) {
    double temp = 0;
    String returnString = "";
    PublicCarpark tempCarpark = carpark as PublicCarpark;
    if(checkOvernightParking(start, end, tempCarpark)){
      if(_centralCarparkNumbers.contains(tempCarpark.carparkId)){
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

class CalculateBikePublicFee implements CalculateFee{
  @override
  String calculateFee(DateTime start, DateTime end, String vehicleSelected, Carpark carpark) {
    double temp = 0;
    String returnString = "";
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
      returnString = "NA";
    }
    if(returnString == ""){
      return double.parse(temp.toStringAsFixed(2)).toString();
    }
    return returnString;
  }
}

class CalculateHeavyPublicFee implements CalculateFee{
  @override
  String calculateFee(DateTime start, DateTime end, String vehicleSelected, Carpark carpark) {
    double temp = 0;
    String returnString = "";
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
      returnString = "NA";
    }
    if(returnString == ""){
      return double.parse(temp.toStringAsFixed(2)).toString();
    }
    return returnString;
  }
}

class CalculatePrivateFee implements CalculateFee{
  @override
  String calculateFee(DateTime start, DateTime end, String vehicleSelected, Carpark carpark) {
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
      if(start.weekday == 7 || _publicHoliday.contains(tempDate)){ //if weekend//public holiday
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
    return double.parse(temp.toStringAsFixed(2)).toString();
  }
}

bool checkOvernightParking(DateTime start, DateTime end, PublicCarpark carpark){
  if(carpark.nightParking == true || //check if night parking available, if not
      (((start.hour>=7 && start.hour<=21) || (start.hour==22 && start.minute<=30)) &&
          ((end.hour>=7 && end.hour<=21) || (end.hour==22 && end.minute<=30)) && end.difference(start).inMinutes < 509)) {
    return true;
  }
  return false;
}