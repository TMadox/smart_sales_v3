import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';

class SaveSensitiveData {
  final storage = locator.get<SharedStorage>().prefs;
  Future<void> saveSensitiveData({
    required String input,
  }) async {
    await storage.setString("user", input);
  }
}
