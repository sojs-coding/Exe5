import 'package:flutter/material.dart';
import 'package:flutter_parkwhere/models/Carpark.dart';
import '../controls/CarparkDetailAndFeeController.dart';
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
                  state.sortBy(choice);
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
                child: state.getCarparkDisplayList().isNotEmpty ? ListView.builder(
                  itemCount: state.getCarparkDisplayList().length,
                     padding: const EdgeInsets.symmetric(vertical: 16),
                     itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(state.getCarparkDisplayList()[index].address),
                          onTap: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                CarparkDetailAndFeeScreen(carparkToShowDetail: state.getCarparkDisplayList()[index])));
                          }
                        );
                      }
                )
                : ListView.builder(
                  itemCount: state.getCarparksToSort().length,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      title: Text(state.getCarparksToSort()[index].address),
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            CarparkDetailAndFeeScreen(carparkToShowDetail: state.getCarparksToSort()[index])));
                      }
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