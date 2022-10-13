import 'package:flutter/material.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Data/Models/options_model.dart';
import 'package:smart_sales/Services/Repositories/dio_repository.dart';

class OptionsState extends ChangeNotifier {
  List<OptionsModel> options = [];
  void fillOptions({required List<OptionsModel> input}) {
    options = List.from(input);
  }

  Future<void> fetchOptions() async {
    final response =
        await locator.get<DioRepository>().get(path: "/get_data_options");
    await SharedStorage.to.prefs.setString("options", response);
  }

  void loadOptions() {
    options = optionsListFromJson(
        input: SharedStorage.to.prefs.getString("options").toString());
  }

  Future<List<OptionsModel>> reloadOptions() async {
    await fetchOptions();
    loadOptions();
    return options;
  }
}
