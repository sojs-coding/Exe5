import 'package:flutter_parkwhere/models/PrivateCarpark.dart';
import 'package:flutter_parkwhere/models/PublicCarpark.dart';
import '../models/Carpark.dart';

mixin CalculateFee {
  static const Iterable<String> centralCarparkNumbers = ['ACB', 'BBB', 'BRB1', 'CY', 'DUXM', 'HLM', 'KAB', 'KAM', 'KAS', 'PRM', 'SLS', 'SR1', 'SR2',
    'TPM', 'UCS', 'WCB'];

  static final Iterable<DateTime> publicHoliday = [DateTime(2023,1,1), DateTime(2023,1,22), DateTime(2023,1,23), DateTime(2023,4,7), DateTime(2023,4,22),
    DateTime(2023,5,1), DateTime(2023,6,2), DateTime(2023,6,29), DateTime(2023,8,9), DateTime(2023,11,23), DateTime(2023,12,25),
    DateTime(2022,1,1), DateTime(2022,2,1), DateTime(2022,2,2), DateTime(2022,4,15), DateTime(2022,5,1), DateTime(2022,5,2), DateTime(2022,5,3),
    DateTime(2022,5,15), DateTime(2022,5,16), DateTime(2022,7,10), DateTime(2022,7,11), DateTime(2022,8,9), DateTime(2022,10,24),
    DateTime(2022,12,25), DateTime(2022,12,26)];

  String calculateFee(DateTime start, DateTime end, String vehicleSelected,
      Carpark carpark);

  bool checkOvernightParking(DateTime start, DateTime end, PublicCarpark carpark){
    if(carpark.nightParking == true || //check if night parking available, if not
        (((start.hour>=7 && start.hour<=21) || (start.hour==22 && start.minute<=30)) &&
            ((end.hour>=7 && end.hour<=21) || (end.hour==22 && end.minute<=30)) && end.difference(start).inMinutes < 509)) {
      return true;
    }
    return false;
  }
}