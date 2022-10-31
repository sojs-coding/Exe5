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
        title: Text(state.carparkDetails.values.elementAt(1)),
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
      body: SingleChildScrollView(
        child: Column(
        children: <Widget> [
          Container(
            height: 200.0,
            width: 350.0,
            margin: const EdgeInsets.only(top: 20.0),
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/carpark.jpg'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
          ),
          Container(
            height: 200,
            //color: Colors.red,
            margin: const EdgeInsets.only(top: 20.0),
            child: Column(
                children: [
                  Text(
                      state.carparkDetails.values.elementAt(2),
                      style: const TextStyle(fontWeight: FontWeight.bold, height: 1.5, fontSize: 20),
                      textAlign: TextAlign.center
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: const EdgeInsets.all(1),
                          child: Text(
                              state.carparkDetails.values.elementAt(3).toString(),
                              style: const TextStyle(height: 1.5, fontSize: 12),
                              textAlign: TextAlign.center
                          )
                      ),
                      Container( //apply margin and padding using Container Widget.
                          padding: const EdgeInsets.all(1), //You can use EdgeInsets like above
                          margin: const EdgeInsets.all(1),
                          child: Text(
                              state.carparkDetails.values.elementAt(4).toString(),
                              style: const TextStyle(height: 1.5, fontSize: 12),
                              textAlign: TextAlign.center
                          )
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left:50, top:25), //apply padding to some sides only
                            child: Text(
                              state.carparkDetails.values.elementAt(0),
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 50, top:25), //apply padding to some sides only
                            child: Text(
                              (state.carparkDetails.values.elementAt(0) == "Private Carpark") ? "Availability: Not Available" : "Availability: ${state.carparkDetails.values.elementAt(15)}",
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          ),
          const Text(
              "Full Information:",
              style: TextStyle(height: 1.5, fontSize: 20),
              textAlign: TextAlign.left
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
                    style: const TextStyle(fontSize: 30)
                  )
                ),
              ),
            )
          )
        ],
        )
      )
    );
  }
}