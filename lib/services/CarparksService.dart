// ignore: file_names
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

abstract class CarparksService {
  String url = 'http://192.168.0.135:5000/';

  Future<Map<String, dynamic>> getCarparks(double x, double y, int carparkCount);

  static Future<Map<String, dynamic>> requestJson(url) async
  {
    int tries = 10;
    Map<String, dynamic> jsonResult = {};
    while (tries > 0) {
      jsonResult = {};
      try {
        var response = await http.get(Uri.parse(url));
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
        print("Error calling for Database API\n$e");
        print("$tries Retry...");
        await Future.delayed(Duration(seconds: 2));
        tries -= 1;
      }
    }

    return jsonResult;
  }
  
}