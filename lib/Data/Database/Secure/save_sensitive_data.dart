import 'package:smart_sales/App/Util/locator.dart';
import 'package:get_storage/get_storage.dart';

class SaveSensitiveData {
  final storage = GetStorage();
  Future<void> saveSensitiveData({
    required String input,
  }) async {
    await storage.write("user", input);
  }
}
