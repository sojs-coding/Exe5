// ignore: file_names
import 'Carpark.dart';

class PrivateCarpark extends Carpark {
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
}