// ignore: file_names
import 'CarparksService.dart';

class AllCarparksService extends CarparksService{
  @override
  Future<Map<String, dynamic>> getCarparks(double x, double y) async {
    String url = '${this.url}carparks/top/all?x_coord=$x&y_coord=$y&limit=5';
    return CarparksService.requestJson(url);
  }
}