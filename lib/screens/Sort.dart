import 'package:flutter/material.dart';
import '../models/PrivateCarpark.dart';
import '../models/PublicCarpark.dart';
import '../services/AllCarparksService.dart';
import '../services/SortService.dart';

class SortScreen extends StatefulWidget {

  final List<dynamic> carparksToSortLatLng;
  const SortScreen({super.key, required this.carparksToSortLatLng});
  @override
  State<SortScreen> createState() => _SortState(carparksLatLng: carparksToSortLatLng);
}

class _SortState extends State<SortScreen> {

  late List<dynamic> carparksLatLng;
  late Future<List<dynamic>> carparksToSort;
  late List<dynamic> carparks;
  late List<dynamic> item = [];
  _SortState({required this.carparksLatLng});
  TextEditingController editingController = TextEditingController();

  @override
  initState() {
    super.initState();
    carparksToSort = _getCarparks(carparksLatLng);
  }
  static const TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: carparksToSort, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {  // AsyncSnapshot<Your object type>
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Loading, please wait', style: textStyle,
                      ),
                    )
                  ]
              )
          );
        }else{
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            carparks = snapshot.data!;
            return Scaffold(
                appBar: AppBar(
                    title: const Text("Sorting"),
                    actions: <Widget>[
                      PopupMenuButton<String>(
                        onSelected: (choice) async {
                          if(choice == 'Sort By: Distance'){
                            List<dynamic> temp = SortService().sortByDistance(carparks, carparksLatLng);
                            setState(() {
                              item.clear();
                              item.addAll(temp);
                            });
                          }
                          if(choice == 'Sort By: Availability'){
                            List<dynamic> temp = SortService().sortByAvailability(carparks, carparksLatLng);
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
                            itemCount: carparks.length,
                            itemBuilder: (BuildContext context, int index){
                              return ListTile(
                                  title: Text(carparks[index].address)
                              );
                            },
                        )
                      )
                    ]
                  )
                )
            );
          }  // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
    );
  }

  Future<List> _getCarparks(List location) async {
    final double lat = location[0];
    final double lng = location[1];
    List<dynamic> carparkToSort = [];

    var response = await AllCarparksService().getCarparks(lat, lng);
    //print(response.length);
    response.forEach((key, value){
      if (value.containsKey('weekday_parking_fare')) {
        carparkToSort.add(PrivateCarpark.fromJson(key, value));
      }
      else {
        carparkToSort.add(PublicCarpark.fromJson(key, value));
      }
    });
    return carparkToSort;
  }

  void filterSearchResults(String query) {
    List<dynamic> dummySearchList = [];
    dummySearchList.addAll(carparks);

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


