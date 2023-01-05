import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/Data/Models/user_model.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Common/Widgets/Dialogs/settings_dialog.dart';
import 'package:smart_sales/View/Screens/Home/home_viewmodel.dart';


class CustomFAB extends StatefulWidget {
  final Widget child;
  const CustomFAB({Key? key, required this.child}) : super(key: key);

  @override
  State<CustomFAB> createState() => _CustomFABState();
}

class _CustomFABState extends State<CustomFAB> {
  final HomeController _homeController = HomeController();
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  String password = "";
  @override
  Widget build(BuildContext context) {
    return HawkFabMenu(
      buttonBorder: const BorderSide(
        color: Color(0xFF074fb3),
        width: 4,
      ),
      fabColor: Colors.white,
      iconColor: const Color(0xFF074fb3),
      items: [
        HawkFabMenuItem(
          label: 'request_reload'.tr,
          ontap: () async {
            EasyLoading.show();
            await _homeController.newRequest(context);
            EasyLoading.dismiss();
          },
          icon: const Icon(Icons.request_page),
          color: Colors.indigo,
        ),
        HawkFabMenuItem(
          label: 'update_items_accounts'.tr,
          ontap: () async {
            await _homeController.updateItemsNclients(context: context);
          },
          icon: const Icon(Icons.upgrade),
          color: Colors.cyan,
        ),
        HawkFabMenuItem(
          label: 'update_items_accounts_with_amount'.tr,
          ontap: () async {
            await _homeController.getNewItemsNclients(context);
          },
          icon: const Icon(Icons.update),
          color: Colors.orange,
        ),
        HawkFabMenuItem(
          label: 'settings'.tr,
          ontap: () async {
            passwordDialog(
              context: context,
              title: 'settings'.tr,
              onCheck: () {
                Navigator.of(context).pushNamed(Routes.settingsRoute);
              },
            );
          },
          icon: const Icon(Icons.settings),
          color: Colors.green,
        ),
        HawkFabMenuItem(
          label: "exit".tr,
          ontap: () async {
            await GetStorage().remove("user");
            context.read<UserState>().setLoggedUser(input: UserModel());
            Navigator.of(context).pushReplacementNamed('/');
          },
          icon: const Icon(Icons.logout),
          color: Colors.red,
        ),
      ],
      body: widget.child,
    );
  }

  // Future<void> deleteReceipts(BuildContext context) async {
  //   final List<Map> operations = ReadData().readOperations();
  //   try {
  //     if (operations.isNotEmpty &&
  //         operations
  //             .where((element) => element["is_sender_complete_status"] == 0)
  //             .isNotEmpty) {
  //       Get.back();
  //       showErrorDialog(
  //         context: context,
  //         title: "error".tr,
  //         description: "operations_not_uploaded_yet".tr,
  //       );
  //     } else {
  //       if (await locator
  //           .get<DeleteRepo>()
  //           .requestDeleteRepo(context: context, operations: operations)) {
  //         throw "operations_not_exported_yet".tr;
  //       }
  //       responseSnackbar(context, "operations_deleted".tr);
  //     }
  //   } catch (e) {
  //     if (e is DioError) {
  //       String message = DioExceptions.fromDioError(e).toString();
  //       showErrorDialog(
  //           context: context, description: message, title: "error".tr);
  //     } else {
  //       showErrorDialog(
  //         context: context,
  //         description: e.toString(),
  //         title: "error".tr,
  //       );
  //     }
  //   }
  // }

}
