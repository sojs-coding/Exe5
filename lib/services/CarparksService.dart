// ignore: file_names
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

abstract class CarparksService {
  String url = 'http://192.168.1.211:5000/';

  Future<Map<String, dynamic>> getCarparks(double x, double y, int carparkCount);

  static Future<Map<String, dynamic>> requestJson(url) async
  {
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> jsonResult = {};
    try {
      if (response.statusCode == 200) {
        var json = convert.jsonDecode(response.body);
        jsonResult = json as Map<String, dynamic>;
        print(jsonResult);
        return jsonResult;
      }
      else {
        return jsonResult;
      }
    } on Exception catch (e) {
      // TODO
      print("Try catch failed: " + e.toString());
    }
    return jsonResult;
  }
  
}