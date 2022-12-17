import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Data/Models/employee.dart';
import 'package:smart_sales/Services/Repositories/dio_repository.dart';

class EmployeesController extends GetxController {
  Rx<List<Employee>> employees = Rx<List<Employee>>([]);
  final searchWord = "".obs;
  set search(String input) {
    searchWord.value = input;
  }

  @override
  onInit() {
    super.onInit();
    loadEmployees();
  }

  Future<void> fetchAndSaveEmployees() async {
    try {
      final response = await DioRepository.to.get(path: '/get_data_employ');
      employees.value = employeeFromMap(response);
      await GetStorage().write("employees", response);
    } catch (e) {
      EasyLoading.showError("error".tr);
    }
  }

  void loadEmployees() {
    employees.value = employeeFromMap(GetStorage().read("employees") ?? "[]");
  }

  List<Employee> filterList() {
    List<Employee> filteredEmployee = [];
    if (searchWord.value != "") {
      filteredEmployee = List.from(
        employees.value.where(
          (element) {
            return (element.name.contains(searchWord.value) ||
                element.id.toString().contains(searchWord.value));
          },
        ).toList(),
      );
      return filteredEmployee;
    } else {
      filteredEmployee = employees.value;
      return filteredEmployee;
    }
  }
}
