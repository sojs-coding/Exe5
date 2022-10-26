// ignore: file_names
import 'CarparksService.dart';

class AllCarparksService extends CarparksService{
  @override
  Future<Map<String, dynamic>> getCarparks(double x, double y, int carparkCount) async {
    String url = '${this.url}carparks/top/all?x_coord=$x&y_coord=$y&limit=$carparkCount';
    return CarparksService.requestJson(url);
  }
}