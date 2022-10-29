import 'package:flutter/material.dart';
import 'package:flutter_parkwhere/controls/CarparkDetailAndFeeController.dart';

class CarparkDetailAndFeeView extends StatelessWidget {
  final CarparkDetailAndFeeState state;

  CarparkDetailAndFeeScreen get widget => state.widget;

  const CarparkDetailAndFeeView(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: (choice) async {
                state.vehicleSelected = choice;
                state.setCalculator();
              },
              itemBuilder: (BuildContext context) {
                return state.vehicleChoice.map<PopupMenuEntry<String>>((ch){
                  return PopupMenuItem<String>(
                      value: ch['title'].toString(),
                      child: ListTile(
                          leading: ch['icon'] as Widget,
                          title: Text(ch['title'].toString())
                      )
                  );
                }).toList();
              }
          )
        ]
      ),
      body: Column(
        children: <Widget> [
          Center(
            child: Card(
              elevation: 0,
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: SizedBox(
                width: 350,
                height: 300,
                child: Center(
                  child:
                    ListView.builder(
                      itemCount: state.carparkDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          visualDensity: const VisualDensity(vertical: -3),
                          title: Text("${state.carparkDetails.keys.elementAt(index)} : ${state.carparkDetails.values.elementAt(index)}"),
                        );
                      }
                    )
                ),
              ),
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget> [
              OutlinedButton(
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black)),
              onPressed: (){
                state.buildStartDate();
              },
              child: Text(state.formattedStartDate, style: const TextStyle(color: Colors.blue),)
              ),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black)),
                  onPressed: (){
                    state.buildEndDate();
                  },
                  child: Text(state.formattedEndDate, style: const TextStyle(color: Colors.blue),)
              )
            ],
          ),
          Center(
            child: Card(
              elevation: 0,
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: SizedBox(
                width: 200,
                height: 100,
                child: Center(
                  child:
                  Text(
                    "\$${state.price}SGD",
                    style: const TextStyle(fontSize: 50)
                  )
                ),
              ),
            )
          )
        ],
      )
    );
  }
}