class Availability {
  late final String? id;
  late final int? availableLots;
  late final int? totalLots;
  late final DateTime? timestamp;

  Availability();

  Availability.fromJson(this.id,Map<dynamic, dynamic> parsedJson)
      : availableLots = parsedJson['lots_available'],
        totalLots = parsedJson['total_lots'],
        timestamp = parsedJson['timestamp'];
}