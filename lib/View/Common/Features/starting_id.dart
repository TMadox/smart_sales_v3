import 'package:smart_sales/Data/Database/Commands/read_data.dart';

class StartingId {
  int get(int sectionTypeNo) {
    if (ReadData().readLastOperations()[sectionTypeNo.toString()] == null) {
      return 1;
    } else {
      return ReadData().readLastOperations()[sectionTypeNo.toString()]
              ["oper_id"] +
          1;
    }
  }
}
