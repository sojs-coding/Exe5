abstract class Carpark {
  late final String carparkId;
  late final String address;
  late final double x_Coord_WGS84;
  late final double y_Coord_WGS84;

  Carpark();

  Carpark.fromJson(String id,Map<dynamic, dynamic> parsedJson)
      : carparkId = id,
        address = parsedJson['address'],
        x_Coord_WGS84 = parsedJson['x_coord_WGS84'],
        y_Coord_WGS84 = parsedJson['y_coord_WGS84'];
}