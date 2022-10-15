import 'package:flutter/material.dart';
import '../models/PrivateCarpark.dart';
import '../models/PublicCarpark.dart';
import '../services/AllCarparksService.dart';
import '../services/SortService.dart';

class SortScreen extends StatefulWidget {

  final List<dynamic> carparksToSort;
  final List<double> currentLocation;
  const SortScreen({super.key, required this.carparksToSort, required this.currentLocation});
  @override
  State<SortScreen> createState() => _SortState(carparksToSort: carparksToSort, currentLocation: currentLocation);
}

class _SortState extends State<SortScreen> {

  late List<dynamic> carparksToSort;
  final List<double> currentLocation;
  late List<dynamic> item = [];
  _SortState({required this.carparksToSort, required this.currentLocation});
  TextEditingController editingController = TextEditingController();

  @override
  initState() {
    super.initState();
  }
  static const TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sorting"),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: (choice) async {
                  if(choice == 'Sort By: Distance'){
                    List<dynamic> temp = SortService().sortByDistance(carparksToSort, currentLocation);
                    setState(() {
                      item.clear();
                      item.addAll(temp);
                    });
                  }
                  if(choice == 'Sort By: Availability'){
                    List<dynamic> temp = SortService().sortByAvailability(carparksToSort, currentLocation);
                    setState(() {
                      item.clear();
                      item.addAll(temp);
                    });
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Sort By: Distance', 'Sort By: Availability'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                 },
              ),
            ]
      ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                onChanged: (value) async {
                  filterSearchResults(value.toUpperCase());
                },
                controller: editingController,
                decoration: const InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                ),
              const SizedBox(height: 20,),
              Expanded(
                child: item.isNotEmpty ? ListView.builder(
                  itemCount: item.length,
                     padding: const EdgeInsets.symmetric(vertical: 16),
                     itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(item[index].address)
                        );
                      }
                )
                : ListView.builder(
                  itemCount: carparksToSort.length,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      title: Text(carparksToSort[index].address)
                    );
                  },
                )
              )
            ]
          )
        )
      );
  }

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

  Widget makeDismissible({required Widget child}) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.of(context).pop(),
    child: GestureDetector(onTap: () {}, child: child),
  );

}


