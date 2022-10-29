// ignore: file_names
import 'package:flutter_parkwhere/interfaces/IsMappable.dart';
import 'Carpark.dart';

class PrivateCarpark extends Carpark implements IsMappable{
  late final double weekdayParkingFare;
  late final double saturdayParkingFare;
  late final double sundayPhParkingFare;
  late final double weekdayEntryFare;
  late final double weekendEntryFare;

  PrivateCarpark();

  PrivateCarpark.fromJson(String id,Map<dynamic, dynamic> parsedJson)
      : weekdayParkingFare = parsedJson['weekday_parking_fare'] ?? 0,
        saturdayParkingFare = parsedJson['saturday_parking_fare'] ?? 0,
        sundayPhParkingFare = parsedJson['sunday_ph_parking_fare'] ?? 0,
        weekdayEntryFare = parsedJson['weekday_entry_fare'] ?? 0,
        weekendEntryFare = parsedJson['weekend_entry_fare'] ?? 0,
        super.fromJson(id, parsedJson);

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map.addAll(super.toMap());
    map.addAll({
      "weekdayParkingFare" : weekdayParkingFare,
      "saturdayParkingFare" : saturdayParkingFare,
      "sundayPhParkingFare" : sundayPhParkingFare,
      "weekdayEntryFare" : weekdayEntryFare,
      "weekendEntryFare" : weekendEntryFare
    });
    return map;
  }
}