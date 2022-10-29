import 'package:flutter_parkwhere/interfaces/IsMappable.dart';

abstract class Carpark implements IsMappable {
  late final String carparkId;
  late final String address;
  late final double xCoordWGS84;
  late final double yCoordWGS84;

  Carpark();

  Carpark.fromJson(String id,Map<dynamic, dynamic> parsedJson)
      : carparkId = id,
        address = parsedJson['address'],
        xCoordWGS84 = parsedJson['x_coord_WGS84'],
        yCoordWGS84 = parsedJson['y_coord_WGS84'];

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "carparkId" : carparkId,
      "address" : address,
      "xCoordWGS84" : xCoordWGS84,
      "yCoordWGS84" : yCoordWGS84,
    };
    return map;
  }
}