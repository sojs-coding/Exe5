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

  late final List<Carpark> carparksToSort = [...widget.carparksToSort];

  late final LatLng currentLocation = widget.currentLocation;

  late final List<Carpark> carparkDisplayList = [];

  @override
  Widget build(BuildContext context) => SortView(this);

  final TextEditingController editingController = TextEditingController();

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
    dummySearchList.addAll(carparksToSort);

    if(query.isNotEmpty) {
      List<Carpark> dummyListData = [];
      for (Carpark item in dummySearchList) {
        if(item.address.toString().toUpperCase().contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        carparkDisplayList.clear();
        carparkDisplayList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        carparkDisplayList.clear();
      });
    }
  }

  void sortBy(String choice) {
    List<Carpark> temp;
    if(choice == 'Sort By: Distance'){
      temp = SortService().sortByDistance(carparksToSort, currentLocation);
    }
    else if(choice == 'Sort By: Availability'){
      temp = SortService().sortByAvailability(carparksToSort);
    }
    else {
      temp = [];
    }
    setState(() {
      carparkDisplayList.clear();
      carparkDisplayList.addAll(temp);
    });
  }
}