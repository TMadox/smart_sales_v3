import 'package:get/get.dart';
import 'package:smart_sales/View/Common/Controllers/upload_controller.dart';
import 'package:smart_sales/View/Screens/Documents/document_controller.dart';
import 'package:smart_sales/View/Screens/Employees/employees_controller.dart';
import 'package:smart_sales/View/Screens/Operations/operations_controller.dart';
import 'package:smart_sales/View/Screens/Receipts/receipts_controller.dart';
import 'package:smart_sales/View/Screens/Recycle/recycle_controller.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeesController(), fenix: true);
    Get.lazyPut(() => DocumentsController(), fenix: true);
    Get.lazyPut(() => OperationsController(), fenix: true);
    Get.lazyPut(() => ReceiptsController(), fenix: true);
    Get.lazyPut(() => RecycleController(), fenix: true);
    Get.put(UploadController());
  }
}
