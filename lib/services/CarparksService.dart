// ignore: file_names
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

abstract class CarparksService {
  String url = 'http://192.168.0.135:5000/';

  Future<Map<String, dynamic>> getCarparks(double x, double y);

  static Future<Map<String, dynamic>> requestJson(url) async
  {
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    Map<String, dynamic> jsonResult = json as Map<String, dynamic>;
    print(jsonResult);
    return jsonResult;
  }
}