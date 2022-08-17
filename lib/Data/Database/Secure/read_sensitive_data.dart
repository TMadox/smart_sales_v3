import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';

class ReadSensitiveData {
  final storage = locator.get<SharedStorage>().prefs;
  String? user;
  Future<String?> readSensitiveData() async {
    if (storage.containsKey("user")) {
      user = storage.getString("user");
      return user;
    } else {
      return null;
    }
  }
}
