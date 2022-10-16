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
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: const SizedBox(
                width: 300,
                height: 100,
                child: Center(
                  child: Text(
                    'details here',
                    style: TextStyle(
                      fontSize: 15
                    ),
                  )
                ),
              ),
            )
          ),
        ],
      )
    );
  }
}