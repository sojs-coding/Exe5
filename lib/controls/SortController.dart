import 'package:flutter/material.dart';
import 'package:flutter_parkwhere/screens/Sort.dart';

class SortScreen extends StatefulWidget {

  final List<dynamic> carparksToSort;
  final List<double> currentLocation;

  const SortScreen({Key? key, required this.carparksToSort, required this.currentLocation}) : super(key: key);
  @override
  State<SortScreen> createState() => SortState();
}

class SortState extends State<SortScreen> {

  late List<dynamic> carparksToSort = widget.carparksToSort;
  late final List<double> currentLocation = widget.currentLocation;
  late List<dynamic> item = [];

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
    List<dynamic> dummySearchList = [];
    dummySearchList.addAll(carparksToSort);

    if(query.isNotEmpty) {
      List<dynamic> dummyListData = [];
      for (var item in dummySearchList) {
        if(item.address.toString().toUpperCase().contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        item.clear();
        item.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        item.clear();
      });
    }
  }
}