import 'dart:convert';
import 'package:get_storage/get_storage.dart';

abstract class BaseController {
  Future<void> saveOperations({
    required List<Map> operations,
    required Map finalOperations,
  }) async {
    await GetStorage().write("operations", json.encode(operations));
    await GetStorage().write("lastOperations", json.encode(finalOperations));
  }
}
