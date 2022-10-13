// ignore: file_names

abstract class CarparksService {
  String url = 'http://192.168.0.135:5000/';

  Future<Map<String, dynamic>> getCarparks(double x, double y);
}