import 'package:flutter/cupertino.dart';
import 'package:flutter_parkwhere/models/Carpark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parkwhere/models/PrivateCarpark.dart';
import 'package:flutter_parkwhere/screens/CarparkDetailAndFee.dart';

import '../models/Carpark.dart';

class CarparkDetailAndFeeScreen extends StatefulWidget {

  final Carpark carparkToShowDetail;

  const CarparkDetailAndFeeScreen({Key? key, required this.carparkToShowDetail}) : super(key: key);

  @override
  State<CarparkDetailAndFeeScreen> createState() => CarparkDetailAndFeeState();
}

class CarparkDetailAndFeeState extends State<CarparkDetailAndFeeScreen> {

  late Carpark carparkToShowDetail = widget.carparkToShowDetail;

  @override
  Widget build(BuildContext context) => CarparkDetailAndFeeView(this);

  @override
  initState() {
    super.initState();
  }

  ListView buildTheCarparkDetails() {
    if (carparkToShowDetail is PrivateCarpark) {
      List<String> header = ['ID', 'Address', 'Lng', 'Lat', 'weekdayFare', 'saturdayFare', 'sundayPhParkingFare', 'weekdayEntryFare', 'weekendEntryFare'];
      //TODO: Consider using ListBody
      return ListView.builder(
        itemCount: header.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('${header[index]} : ${carparkToShowDetail.address}'),
          );
        }
      );
    }
    else{
      return ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(carparkToShowDetail.address),
          );
        }
      );
    }
  }

  num calculateFee(Carpark carpark, int durationInMinutes) {
    return carpark.getFee(durationInMinutes);
  }
}