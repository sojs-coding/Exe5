import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService {
  final String key = 'API_KEY';

  Future<String> getPlaceId(String input) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    String placeId = '';
    print(json);
    var jsonStatus = json['status'] as String;
    if (jsonStatus != 'ZERO_RESULTS') {
      placeId = json['candidates'][0]['place_id'] as String;
      print(placeId);
      return placeId;
    } 
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    Map<String, dynamic> results = {};
    if(placeId.isNotEmpty) {
      final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
      var response = await http.get(Uri.parse(url));
      var json = convert.jsonDecode(response.body);
      results = json['result'] as Map<String, dynamic>;
      print(results);
      return results;
    } 
    return results;
  }
}
