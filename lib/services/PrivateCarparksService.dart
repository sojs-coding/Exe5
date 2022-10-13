// ignore: file_names
import 'package:flutter_parkwhere/models/PrivateCarpark.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'CarparksService.dart';

class PrivateCarparksService extends CarparksService{

  @override
  Future<Map<String, dynamic>> getCarparks(double x, double y) async {
    String url = '${this.url}carparks/top/private?x_coord=$x&y_coord=$y&limit=5';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    /*json.forEach((key, value){
      print('key is $key');
      print('value is $value ');
    });*/
    var jsonResult = json as Map<String, dynamic>;
    print(jsonResult);
    return jsonResult;
  }
}