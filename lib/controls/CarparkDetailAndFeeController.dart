import 'package:flutter/cupertino.dart';
import 'package:flutter_parkwhere/screens/CarparkDetailAndFee.dart';

class CarparkDetailAndFeeScreen extends StatefulWidget {
  const CarparkDetailAndFeeScreen({Key? key}) : super(key: key);

  @override
  State<CarparkDetailAndFeeScreen> createState() => CarparkDetailAndFeeState();
}

class CarparkDetailAndFeeState extends State<CarparkDetailAndFeeScreen> {
  @override
  Widget build(BuildContext context) => CarparkDetailAndFeeView(this);

  @override
  initState() {
    super.initState();
  }
}