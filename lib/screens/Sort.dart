import 'package:flutter/material.dart';
import '../controls/SortController.dart';
import '../services/SortService.dart';

class SortView extends StatelessWidget {
  final SortState state;

  SortScreen get widget => state.widget;

  const SortView(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sorting"),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: (choice) async {
                  if(choice == 'Sort By: Distance'){
                    List<dynamic> temp = SortService().sortByDistance(state.carparksToSort, state.currentLocation);
                    state.setState(() {
                      state.item.clear();
                      state.item.addAll(temp);
                    });
                  }
                  if(choice == 'Sort By: Availability'){
                    List<dynamic> temp = SortService().sortByAvailability(state.carparksToSort, state.currentLocation);
                    state.setState(() {
                      state.item.clear();
                      state.item.addAll(temp);
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
                  state.filterSearchResults(value.toUpperCase());
                },
                controller: state.editingController,
                decoration: const InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                ),
              const SizedBox(height: 20,),
              Expanded(
                child: state.item.isNotEmpty ? ListView.builder(
                  itemCount: state.item.length,
                     padding: const EdgeInsets.symmetric(vertical: 16),
                     itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(state.item[index].address)
                        );
                      }
                )
                : ListView.builder(
                  itemCount: state.carparksToSort.length,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      title: Text(state.carparksToSort[index].address)
                    );
                  },
                )
              )
            ]
          )
        )
      );
  }
}