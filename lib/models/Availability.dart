class Availability {
  //late final String? id;
  late final int? availableLots;
  //late final int? totalLots;
  late final DateTime? _timestamp;

  DateTime? getTimestamp() {
    return _timestamp;
  }

  set timestamp(String value) {
    final split = value.split(',');
    split[0] = split[0].trim();
    final dateSplit = split[0].split('/');
    split[1] = split[1].trim();
    final timeSplit = split[1].split(':');

    _timestamp = DateTime.parse("${dateSplit[2]}${dateSplit[0]}${dateSplit[1]}T${timeSplit[0]}${timeSplit[1]}${timeSplit[2]}");
  }

  Availability();

  Availability.fromJson(String ts, this.availableLots) {
    timestamp = ts;
  }
}