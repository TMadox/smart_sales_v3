import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:smart_sales/Data/Database/Commands/read_data.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Services/Helpers/exceptions.dart';
import 'package:smart_sales/Services/Repositories/dio_repository.dart';

class UploadController extends GetxController {
  bool isUploading = false;
  Future<void> commit({required bool showLoading}) async {
    try {
      if (!isUploading) {
        if (showLoading) {
          EasyLoading.show();
        }
        isUploading = true;
        String error = "حدث خطا في رفع كل او بعض الفواتير";
        bool foundError = false;
        final List<Map> operations = ReadData().readOperations();
        for (Map operation in operations
            .where((element) => (element["is_sender_complete_status"] != 1))) {
          final List products = json.decode(
            operation["products"] ?? "[]",
          );
          final response = await DioRepository.to.post(
            path: "/update_fat_head_data",
            data: [
              [operation],
              products,
              null
            ],
          );
          if (response == "[]" ||
              response == -1 ||
              response == -19 ||
              response == -30) {
            foundError = true;
            switch (response) {
              case -1:
                {
                  error = "خطأ عام";
                  break;
                }
              case -19:
                {
                  error = "بعض الفواتير مكررة";
                  break;
                }
              case -30:
                {
                  error = "السرفر مشغول";
                  break;
                }
              case "[]":
                {
                  error = "يوجد خطأ في الرفع";
                  break;
                }
              default:
            }
            Map receipt = operation;
            receipt["is_sender_complete_status"] = 0;
            receipt["upload_code"] = response;
            operations[operations.indexOf(receipt)] = receipt;
          } else {
            Map receipt = operation;
            receipt["is_sender_complete_status"] = 1;
            receipt["upload_code"] = response;
            operations[operations.indexOf(receipt)] = receipt;
          }
        }
        await SaveData().saveOperationsData(operations: operations);
        EasyLoading.dismiss();
        if (foundError) throw error;
      }
    } catch (e) {
      if (e is DioError) {
        EasyLoading.showError(DioExceptions.fromDioError(e).message);
      } else {
        EasyLoading.showError(e.toString());
      }
    } finally {
      isUploading = false;
    }
  }
}
