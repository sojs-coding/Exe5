import 'package:flutter_parkwhere/controls/CalculateBikePublicFee.dart';
import 'package:flutter_parkwhere/controls/CalculateCarPublicFee.dart';
import 'package:flutter_parkwhere/controls/CalculateHeavyPublicFee.dart';
import 'package:flutter_parkwhere/controls/CalculatePrivateFee.dart';
import 'package:flutter_parkwhere/models/Carpark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parkwhere/models/PrivateCarpark.dart';
import 'package:flutter_parkwhere/models/PublicCarpark.dart';
import 'package:flutter_parkwhere/screens/CarparkDetailAndFee.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:date_format/date_format.dart';
import '../interfaces/CalculateFee.dart';

class CarparkDetailAndFeeScreen extends StatefulWidget {

  final Carpark carparkToShowDetail;

  const CarparkDetailAndFeeScreen({Key? key, required this.carparkToShowDetail}) : super(key: key);

  @override
  State<CarparkDetailAndFeeScreen> createState() => CarparkDetailAndFeeState();
}

class CarparkDetailAndFeeState extends State<CarparkDetailAndFeeScreen> {

  late final Carpark _carparkToShowDetail = widget.carparkToShowDetail;
  late Map<String, dynamic> _carparkDetails;
  Map<String, dynamic> get carparkDetails => _carparkDetails;

  late DateTime _endDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute);
  late DateTime _startDate = _endDate;
  late String _formattedStartDate = formatDate(_startDate, [dd,'-',mm,'-',yy,' ',HH,':',nn]);
  late String _formattedEndDate = formatDate(_endDate, [dd,'-',mm,'-',yy,' ',HH,':',nn]);
  String get formattedStartDate => _formattedStartDate;
  String get formattedEndDate => _formattedEndDate;

  String _price = "0.0";
  String get price => _price;

  final _vehicleChoice = [
    {'title': 'Car', 'icon': const Icon(Icons.directions_car_filled_outlined)},
    {'title': 'Bike', 'icon': const Icon(Icons.directions_bike_outlined)},
    {'title': 'Heavy', 'icon': const Icon(Icons.local_shipping_outlined)}
  ];

  get vehicleChoice => _vehicleChoice;

  String vehicleSelected = 'Car';

  late CalculateFee _calculator;

  @override
  Widget build(BuildContext context) => CarparkDetailAndFeeView(this);

  @override
  initState() {
    super.initState();
    _carparkDetails = {};
    _carparkDetails.addAll(
        {"Carpark Access" : (_carparkToShowDetail is PublicCarpark)
            ? "Public Carpark" : "Private Carpark"});
    _carparkDetails.addAll(_carparkToShowDetail.toMap());
    if (_carparkToShowDetail is PublicCarpark) {
      _carparkDetails.addAll({"Available Lots" : (_carparkToShowDetail as PublicCarpark).getLatestAvailability()?.availableLots});
    }
    setCalculator();
  }

  void buildStartDate(){
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
          _startDate = startDate;
          _formattedStartDate = formatDate(startDate, [dd,'-',mm,'-',yy,' ',HH,':',nn]);
          double priceDouble = _calculator.calculateFee(_startDate, _endDate, vehicleSelected, _carparkToShowDetail);
          if(priceDouble != -1){
            _price = double.parse(priceDouble.toStringAsFixed(2)).toString();
          }
          else{
            _price = "NA";
          }
        });
        },
        currentTime: _startDate);
  }

  void buildEndDate(){
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
          _endDate = endDate;
          _formattedEndDate = formatDate(endDate, [dd,'-',mm,'-',yy,' ',HH,':',nn]);
          double priceDouble = _calculator.calculateFee(_startDate, _endDate, vehicleSelected, _carparkToShowDetail);
          if(priceDouble != -1){
            _price = double.parse(priceDouble.toStringAsFixed(2)).toString();
          }
          else{
            _price = "NA";
          }
        });
        },
        currentTime: _endDate);
  }

  void setCalculator(){
    if(_carparkToShowDetail is PrivateCarpark){
      _calculator = CalculatePrivateFee();
    }
    else {
      if (vehicleSelected == 'Car') {
        _calculator = CalculateCarPublicFee();
      }
      else if(vehicleSelected == 'Bike'){
        _calculator = CalculateBikePublicFee();
      }
      else if(vehicleSelected == 'Heavy'){
        _calculator = CalculateHeavyPublicFee();
      }
    }
    setState(() {
      double priceDouble = _calculator.calculateFee(_startDate, _endDate, vehicleSelected, _carparkToShowDetail);
      if(priceDouble != -1){
        _price = double.parse(priceDouble.toStringAsFixed(2)).toString();
      }
      else{
        _price = "NA";
      }
    });
  }


}