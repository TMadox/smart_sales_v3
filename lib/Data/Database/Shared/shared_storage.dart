import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_sales/App/Resources/strings_manager.dart';
import 'package:smart_sales/App/Util/locator.dart';

class SharedStorage {
  late SharedPreferences _preferences;

  init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedStorage get to => locator.get();

  SharedPreferences get prefs => _preferences;

  String get ipPassword {
    return _preferences.getString(StringsManager.ipPassword) ?? "";
  }

  String get ipAddress {
    return _preferences.getString(StringsManager.ipAddress) ?? "";
  }

  bool get loggedBefore {
    return _preferences.getBool(StringsManager.loggedBefore) ?? false;
  }

  String get userId {
    return _preferences.getString(StringsManager.userId) ?? "";
  }

  set loggedBefore(bool input) {
    _preferences.setBool(StringsManager.loggedBefore, input);
  }
}
