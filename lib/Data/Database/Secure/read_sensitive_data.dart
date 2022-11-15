import 'package:smart_sales/App/Util/locator.dart';
import 'package:get_storage/get_storage.dart';

class ReadSensitiveData {
  final storage = GetStorage();
  String? user;
  Future<String?> readSensitiveData() async {
    if (storage.hasData("user")) {
      user = storage.read("user");
      return user;
    } else {
      return null;
    }
  }
}
