// ignore: file_names
import 'package:flutter_parkwhere/services/CarparksService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PublicCarparksService extends CarparksService{
  /*Future<List<PublicCarparks>> getPublicCarparks(double x, double y) async {
    final String url = 'http://192.168.1.211:5000/carparks?x_coord=$x&y_coord=$y&limit=5';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json as List;
    print(jsonResult);
    return jsonResult.map((publicCarparks) => PublicCarparks.fromJson(publicCarparks)).toList();
  }*/

  @override
  Future<Map<String, dynamic>> getCarparks(double x, double y) async {
    String url = '${this.url}carparks/top/public?x_coord=$x&y_coord=$y&limit=5';
    return CarparksService.requestJson(url);
  }
}