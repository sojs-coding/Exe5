// ignore: file_names
class PublicCarparks {
  final String carparkId;
  final String address;
  final double x_coord_WGS84;
  final double y_coord_WGS84;

  PublicCarparks(this.carparkId, this.address, this.x_coord_WGS84, this.y_coord_WGS84);

  PublicCarparks.fromJson(String id,Map<dynamic, dynamic> parsedJson)
    :carparkId = id,
    address = parsedJson['address'],
    x_coord_WGS84 = parsedJson['x_coord_WGS84'],
    y_coord_WGS84 = parsedJson['y_coord_WGS84'];
}