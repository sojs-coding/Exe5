import 'package:flutter/cupertino.dart';
import 'package:flutter_parkwhere/models/Carpark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parkwhere/models/PrivateCarpark.dart';
import 'package:flutter_parkwhere/models/PublicCarpark.dart';
import 'package:flutter_parkwhere/screens/CarparkDetailAndFee.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:date_format/date_format.dart';

import '../models/Carpark.dart';

class CarparkDetailAndFeeScreen extends StatefulWidget {

  final Carpark carparkToShowDetail;

  const CarparkDetailAndFeeScreen({Key? key, required this.carparkToShowDetail}) : super(key: key);

  @override
  State<CarparkDetailAndFeeScreen> createState() => CarparkDetailAndFeeState();
}

class CarparkDetailAndFeeState extends State<CarparkDetailAndFeeScreen> {

  late Carpark _carparkToShowDetail = widget.carparkToShowDetail;

  late DateTime _endDate = DateTime.now();
  late var _formattedStartDate = formatDate(_startDate, [dd,'-',mm,'-',yy,' ',HH,':',nn]);
  late DateTime _startDate = DateTime.now();
  late var _formattedEndDate = formatDate(_endDate, [dd,'-',mm,'-',yy,' ',HH,':',nn]);
  String _price = "\$0.0";

  List<String> _centralCarparkNumbers = ['ACB', 'BBB', 'BRB1', 'CY', 'DUXM', 'HLM', 'KAB', 'KAM', 'KAS', 'PRM', 'SLS', 'SR1', 'SR2',
    'TPM', 'UCS', 'WCB'];
  List<DateTime> _publicHoliday = [DateTime(2023,1,1), DateTime(2023,1,22), DateTime(2023,1,23), DateTime(2023,4,7), DateTime(2023,4,22),
    DateTime(2023,5,1), DateTime(2023,6,2), DateTime(2023,6,29), DateTime(2023,8,9), DateTime(2023,11,23), DateTime(2023,12,25),
    DateTime(2022,1,1), DateTime(2022,2,1), DateTime(2022,2,2), DateTime(2022,4,15), DateTime(2022,5,1), DateTime(2022,5,2), DateTime(2022,5,3),
    DateTime(2022,5,15), DateTime(2022,5,16), DateTime(2022,7,10), DateTime(2022,7,11), DateTime(2022,8,9), DateTime(2022,10,24),
    DateTime(2022,12,25), DateTime(2022,12,26)];

  final _vehicleChoice = [
    {'title': 'Car', 'icon': const Icon(Icons.directions_car_filled_outlined)},
    {'title': 'Bike', 'icon': const Icon(Icons.directions_bike_outlined)},
    {'title': 'Heavy', 'icon': const Icon(Icons.local_shipping_outlined)}
  ];
  var _vehicleSelected = 'Car';

  @override
  Widget build(BuildContext context) => CarparkDetailAndFeeView(this);

  @override
  initState() {
    super.initState();
  }

  PopupMenuButton buildVehicleType(){
    return PopupMenuButton<String>(
        onSelected: (choice) async {
          _vehicleSelected = choice;
          calculateFee(_startDate, _endDate);
        },
        itemBuilder: (BuildContext context) {
          return _vehicleChoice.map((ch){
            return PopupMenuItem<String>(
                value: ch['title'].toString(),
                child: ListTile(
                    leading: ch['icon'] as Widget,
                    title: Text(ch['title'].toString())
                )
            );
          }).toList();
        }
    );
  }

  ListView buildTheCarparkDetails() {
    List<String> list = getAttribute(_carparkToShowDetail);
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          visualDensity: const VisualDensity(vertical: -3),
          title: Text(list[index]),
        );
      }
    );
  }

  OutlinedButton buildStartDate(){
    return OutlinedButton(
        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black)),
        onPressed: (){
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
              maxTime: DateTime(DateTime.now().year+1, 12, 31),
              theme: const DatePickerTheme(headerColor: Colors.blue,
                  backgroundColor: Colors.white,
                  itemStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  doneStyle:TextStyle(color: Colors.white, fontSize: 16)),
              onConfirm: (startDate) {setState(() {
                _formattedStartDate = formatDate(startDate, [dd,'-',mm,'-',yy,' ',HH,':',nn]);
              });
                calculateFee(startDate,_endDate);
              },
              currentTime: _startDate);
        },
        child: Text(_formattedStartDate, style: const TextStyle(color: Colors.blue),)
    );
  }

  OutlinedButton buildEndDate(){
    return OutlinedButton(
        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black)),
        onPressed: (){
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
              maxTime: DateTime(DateTime.now().year+1, 12, 31),
              theme: const DatePickerTheme(headerColor: Colors.blue,
                  backgroundColor: Colors.white,
                  itemStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  doneStyle:TextStyle(color: Colors.white, fontSize: 16)),
              onConfirm: (endDate) { setState(() {
                _formattedEndDate = formatDate(endDate, [dd,'-',mm,'-',yy,' ',HH,':',nn]);
              });
              calculateFee(_startDate,endDate);
              },
              currentTime: _endDate);
        },
        child: Text(_formattedEndDate, style: const TextStyle(color: Colors.blue),)
    );
  }

  List<String> getAttribute(Carpark carpark){
    List<String> returnlist = [];
    returnlist.add("ID: ${carpark.carparkId}");
    returnlist.add("Address: ${carpark.address}");
    returnlist.add("Lng: ${carpark.xCoordWGS84}");
    returnlist.add("Lat: ${carpark.yCoordWGS84}");
    if(carpark is PrivateCarpark){
      if(carpark.weekdayParkingFare != 0) {
        returnlist.add("Weekday Fare: ${carpark.weekdayParkingFare}");
      }
      if(carpark.saturdayParkingFare != 0) {
        returnlist.add("Saturday Fare: ${carpark.saturdayParkingFare}");
      }
      if(carpark.sundayPhParkingFare != 0) {
        returnlist.add("Sunday/PH Fare: ${carpark.sundayPhParkingFare}");
      }
      if(carpark.weekdayEntryFare != 0) {
        returnlist.add("Weekday Entry Fee: ${carpark.weekdayEntryFare}");
      }
      if(carpark.weekendEntryFare != 0) {
        returnlist.add("Weekend Entry Fee: ${carpark.weekendEntryFare}");
      }
    }
    if(carpark is PublicCarpark){
      returnlist.add("Carpark Type: ${carpark.carparkType}");
      returnlist.add("Electronic Parking: ${carpark.electronicParkingSystem}");
      returnlist.add("Short Term Parking: ${carpark.shortTermParking}");
      returnlist.add("Free Parking: ${carpark.freeParking}");
      returnlist.add("Night Parking: ${carpark.nightParking}");
      returnlist.add("Carpark Deck Number: ${carpark.carparkDeckNumber}");
      returnlist.add("Gantry Height: ${carpark.gantryHeight}");
      returnlist.add("Carpark Basement: ${carpark.carparkBasement}");
    }
    return returnlist;
  }

  Text buildFee() {
    return Text(
      _price,
      style: const TextStyle(fontSize: 50)
    );
  }

  void calculateFee(DateTime start, DateTime end) {
    if(_carparkToShowDetail is PrivateCarpark){
      calculateFee(start, end);
    }
    else {
      if (_vehicleSelected == 'Car') {
        calculateFeeCarHDB(start, end);
      }
      else if(_vehicleSelected == 'Bike'){
        calculateFeeBikeHDB(start, end);
      }
      else if(_vehicleSelected == 'Heavy'){
        calculateFeeHeavyHDB(start, end);
      }
    }
  }

  void calculateFeePrivate(DateTime start, DateTime end){
    double temp = 0;
    DateTime tempStart = start;
    DateTime tempEnd = end;
    String returnString = "";
    PrivateCarpark tempCarpark = _carparkToShowDetail as PrivateCarpark;
    if(start.compareTo(end) < 0) {
      if (start.weekday < 6) {
        temp += tempCarpark.weekdayEntryFare;
      }
      else {
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
    setState(() {
      if(returnString == "") {
        _price = double.parse(temp.toStringAsFixed(2)).toString();
      }
      else{
        _price = returnString;
      }
      _startDate = tempStart;
      _endDate = tempEnd;
    });
  }

  void calculateFeeCarHDB(DateTime start, DateTime end){
    double temp = 0;
    DateTime tempStart = start;
    DateTime tempEnd = end;
    String returnString = "";
    PublicCarpark tempCarpark = _carparkToShowDetail as PublicCarpark;
    if(tempCarpark.nightParking == true || //check if night parking available, if not
        (((start.hour>=7 && start.hour<=21) || (start.hour==22 && start.minute<=30)) &&
            ((end.hour>=7 && end.hour<=21) || (end.hour==22 && end.minute<=30)) && end.difference(start).inMinutes < 509)) { //check if start - end within day time
      if (_centralCarparkNumbers.contains(_carparkToShowDetail.carparkId)) { //check if carpark is in central area
        int interval30minOffPeak = 0;
        int interval30minPeak = 0;
        int interval30minNight = 0;
        int numOfCap = 0;
        while (start.compareTo(end) < 0) {
          DateTime temp = start.add(const Duration(minutes: 30));
          if (start.weekday == 7 || (start.hour > 16 || start.hour < 7)) { //current time within peak period
            if (temp.weekday == 7 || (temp.hour > 16 || temp.hour < 7)) { //current time + 30 within peak period
              start = temp;
            }
            else {
              while (temp.weekday == 7 || (temp.hour > 16 || temp.hour < 7)) { //current time += 1min until out of peak period
                start = start.add(const Duration(minutes: 1));
              }
            }
            interval30minPeak++;
          }
          else { //current time outside peak period
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
            if (!(temp.weekday == 7 || (temp.hour > 16 || temp.hour < 7))) { //current time + 30 outside peak period
              start = temp;
            }
            else {
              while (!(temp.weekday == 7 || (temp.hour > 16 || temp.hour < 7))) { //current time += 1min until within peak period
                start = start.add(const Duration(minutes: 1));
              }
            }
            interval30minOffPeak++;
          }
        }
        temp = 1.2 * interval30minPeak + 0.6 * interval30minOffPeak + 5 * numOfCap;
      }
      else { //if carpark not in central area
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

    setState(() {
      if(returnString == "") {
        _price = double.parse(temp.toStringAsFixed(2)).toString();
      }
      else{
        _price = returnString;
      }
      _startDate = tempStart;
      _endDate = tempEnd;
    });
  }

  void calculateFeeBikeHDB(DateTime start, DateTime end){
    double temp = 0;
    DateTime tempStart = start;
    DateTime tempEnd = end;
    String returnString = "";
    PublicCarpark tempCarpark = _carparkToShowDetail as PublicCarpark;
    if(tempCarpark.nightParking == true || //check if night parking available, if not
        (((start.hour>=7 && start.hour<=21) || (start.hour==22 && start.minute<=30)) &&
            ((end.hour>=7 && end.hour<=21) || (end.hour==22 && end.minute<=30)) && end.difference(start).inMinutes < 509)) {//check if start - end within day time
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

    setState(() {
      if(returnString == "") {
        _price = double.parse(temp.toStringAsFixed(2)).toString();
      }
      else{
        _price = returnString;
      }
      _startDate = tempStart;
      _endDate = tempEnd;
    });
  }

  void calculateFeeHeavyHDB(DateTime start, DateTime end){
    double temp = 0;
    DateTime tempStart = start;
    DateTime tempEnd = end;
    String returnString = "";
    PublicCarpark tempCarpark = _carparkToShowDetail as PublicCarpark;
    if(tempCarpark.nightParking == true || //check if night parking available, if not
        (((start.hour>=7 && start.hour<=21) || (start.hour==22 && start.minute<=30)) &&
            ((end.hour>=7 && end.hour<=21) || (end.hour==22 && end.minute<=30)) && end.difference(start).inMinutes < 509)) {//check if start - end within day time
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

    setState(() {
      if(returnString == "") {
        _price = double.parse(temp.toStringAsFixed(2)).toString();
      }
      else{
        _price = returnString;
      }
      _startDate = tempStart;
      _endDate = tempEnd;
    });
  }
}