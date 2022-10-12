// ignore: file_names
import 'package:flutter_parkwhere/models/publicCarparks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PublicCarparksService {
  /*Future<List<PublicCarparks>> getPublicCarparks(double x, double y) async {
    final String url = 'http://192.168.1.211:5000/carparks?x_coord=$x&y_coord=$y&limit=5';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json as List;
    print(jsonResult);
    return jsonResult.map((publicCarparks) => PublicCarparks.fromJson(publicCarparks)).toList();
  }*/

  Future<Map<String, dynamic>>  getPublicCarparks(double x, double y) async {
    final String url = 'http://192.168.0.135:5000/carparks/top/all?x_coord=$x&y_coord=$y&limit=5';
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