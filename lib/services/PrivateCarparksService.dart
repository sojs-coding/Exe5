// ignore: file_names
import 'CarparksService.dart';

class PrivateCarparksService extends CarparksService{

  @override
  Future<Map<String, dynamic>> getCarparks(double x, double y, int carparkCount) async {
    String url = '${this.url}carparks/top/private?x_coord=$x&y_coord=$y&limit=$carparkCount';
    return CarparksService.requestJson(url);
  }
}