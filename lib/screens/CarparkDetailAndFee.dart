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
        title: const Text("Details")
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
                  child: state.buildTheCarparkDetails()
                ),
              ),
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget> [
              state.buildStartDate(),
              state.buildEndDate()
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
                  child: state.calculateFee()
                ),
              ),
            )
          )
        ],
      )
    );
  }
}