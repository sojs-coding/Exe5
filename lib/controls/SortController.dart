import 'package:flutter/material.dart';
import 'package:flutter_parkwhere/models/Carpark.dart';
import 'package:flutter_parkwhere/screens/Sort.dart';
import 'package:flutter_parkwhere/services/SortService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SortScreen extends StatefulWidget {

  final List<Carpark> carparksToSort;
  final LatLng currentLocation;

  const SortScreen({Key? key, required this.carparksToSort, required this.currentLocation}) : super(key: key);
  @override
  State<SortScreen> createState() => SortState();
}

class SortState extends State<SortScreen> {

  late final List<Carpark> _carparksToSort = [...widget.carparksToSort];

  getCarparksToSort() {
    return _carparksToSort;
  }

  late LatLng _currentLocation = widget.currentLocation;

  getCurrentLocation() {
    return _currentLocation;
  }

  late final List<Carpark> _carparkDisplayList = [];

  List<Carpark> getCarparkDisplayList() {
    return _carparkDisplayList;
  }

  @override
  Widget build(BuildContext context) => SortView(this);

  TextEditingController editingController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.of(context).pop(),
    child: GestureDetector(onTap: () {}, child: child),
  );

  void filterSearchResults(String query) {
    List<Carpark> dummySearchList = [];
    dummySearchList.addAll(_carparksToSort);

    if(query.isNotEmpty) {
      List<Carpark> dummyListData = [];
      for (Carpark item in dummySearchList) {
        if(item.address.toString().toUpperCase().contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        _carparkDisplayList.clear();
        _carparkDisplayList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _carparkDisplayList.clear();
      });
    }
  }

  void sortBy(String choice) {
    List<Carpark> temp;
    if(choice == 'Sort By: Distance'){
      temp = SortService().sortByDistance(_carparksToSort, _currentLocation);
    }
    else if(choice == 'Sort By: Availability'){
      temp = SortService().sortByAvailability(_carparksToSort);
    }
    else {
      temp = [];
    }
    setState(() {
      _carparkDisplayList.clear();
      _carparkDisplayList.addAll(temp);
    });
  }
}