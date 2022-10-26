// ignore: file_names
import 'CarparksService.dart';

class SearchCarparkID extends CarparksService{
  @override
  Future<Map<String, dynamic>> getCarpark(String carparkID) async {
    String url = '${this.url}carparks/id?carpark_id=$carparkID';
    return CarparksService.requestJson(url);
  }
  
  @override
  Future<Map<String, dynamic>> getCarparks(double x, double y, int carparkCount) {
    // TODO: implement getCarparks
    throw UnimplementedError();
  }
}