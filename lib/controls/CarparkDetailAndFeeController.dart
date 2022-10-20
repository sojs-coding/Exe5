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

  late Carpark carparkToShowDetail = widget.carparkToShowDetail;

  late DateTime startDate = DateTime.now();
  late var formattedStartDate = formatDate(startDate, [dd,'-',mm,'-',yy,' ',HH,':',nn]);
  late DateTime endDate = DateTime.now();
  late var formattedEndDate = formatDate(endDate, [dd,'-',mm,'-',yy,' ',HH,':',nn]);

  @override
  Widget build(BuildContext context) => CarparkDetailAndFeeView(this);

  @override
  initState() {
    super.initState();
  }

  ListView buildTheCarparkDetails() {
    List<String> list = getAttribute(carparkToShowDetail);
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
                formattedStartDate = formatDate(startDate, [dd,'-',mm,'-',yy,' ',HH,':',nn]);
              });
              },
              currentTime: DateTime.now(), locale: LocaleType.en);
        },
        child: Text(formattedStartDate, style: const TextStyle(color: Colors.blue),)
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
              onConfirm: (endDate) {setState(() {
                formattedEndDate = formatDate(endDate, [dd,'-',mm,'-',yy,' ',HH,':',nn]);
              });
              },
              currentTime: DateTime.now(), locale: LocaleType.en);
        },
        child: Text(formattedEndDate, style: const TextStyle(color: Colors.blue),)
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

  num calculateFee(Carpark carpark, int durationInMinutes) {
    return carpark.getFee(durationInMinutes);
  }
}