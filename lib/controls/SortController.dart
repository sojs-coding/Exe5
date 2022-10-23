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

  late List<Carpark> _carparksToSort = widget.carparksToSort;

  getCarparksToSort() {
    return _carparksToSort;
  }

  late final LatLng _currentLocation = widget.currentLocation;

  getCurrentLocation() {
    return _currentLocation;
  }

  late List<Carpark> _carparkDisplayList = [];

  List<Carpark> getCarparkDisplayList() {
    return _carparkDisplayList;
  }

  @override
  Widget build(BuildContext context) => SortView(this);

  //_SortState({required this.carparksToSort, required this.currentLocation});
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
      for (var item in dummySearchList) {
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
    if(choice == 'Sort By: Distance'){
      List<Carpark> temp = SortService().sortByDistance(getCarparksToSort(), getCurrentLocation());
      setState(() {
        _carparkDisplayList.clear();
        _carparkDisplayList.addAll(temp);
      });
    }
    if(choice == 'Sort By: Availability'){
      List<Carpark> temp = SortService().sortByAvailability(getCarparksToSort());
      setState(() {
        _carparkDisplayList.clear();
        _carparkDisplayList.addAll(temp);
      });
    }
  }
}