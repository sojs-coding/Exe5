// ignore: file_names
import 'CarparksService.dart';

class PrivateCarparksService extends CarparksService{

  @override
  Future<Map<String, dynamic>> getCarparks(double x, double y) async {
    String url = '${this.url}carparks/top/private?x_coord=$x&y_coord=$y&limit=5';
    return CarparksService.requestJson(url);
  }
}