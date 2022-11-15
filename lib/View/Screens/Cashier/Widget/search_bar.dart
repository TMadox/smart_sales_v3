import 'package:badges/badges.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Util/colors.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Settings/subviews/cashier_settings_view.dart';
import 'package:smart_sales/View/Widgets/Common/custom_textfield.dart';
import 'package:smart_sales/View/Widgets/Dialogs/exit_dialog.dart';
import 'package:smart_sales/View/Widgets/Dialogs/general_dialog.dart';

class SearchBar extends StatelessWidget {
  final Map data;
  final GeneralState generalState;
  final Function(String?)? onChanged;
  final GetStorage storage;
  final Function() onTap;
  const SearchBar({
    Key? key,
    required this.data,
    this.onChanged,
    required this.storage,
    required this.generalState,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NeumorphicButton(
          margin: const EdgeInsets.all(5),
          child: const Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          onPressed: () {
            if (context.read<GeneralState>().receiptItems.isNotEmpty) {
              generalDialog(
                title: "warning".tr,
                context: context,
                message: 'receipt_still_inprogress'.tr,
                onCancelText: 'exit'.tr,
                onOkText: 'stay'.tr,
                onCancel: () {
                  if (storage.read("request_visit") ?? false) {
                    exitDialog(
                      context: context,
                      data: data,
                    );
                    return false;
                  } else {
                    Get.back();
                  }
                },
              );
            } else {
              if ((GetStorage().read("request_visit") ?? false)) {
                exitDialog(
                  context: context,
                  data: data,
                );
              } else {
                Get.back();
              }
            }
          },
          style: const NeumorphicStyle(
            color: Colors.red,
            shape: NeumorphicShape.concave,
            surfaceIntensity: 50,
            shadowDarkColor: Colors.black,
          ),
        ),
        NeumorphicButton(
          margin: const EdgeInsets.all(5),
          child: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: () {
            Get.to(() => const CashierSettingsView());
          },
          style: const NeumorphicStyle(
            color: Colors.green,
            shape: NeumorphicShape.concave,
            surfaceIntensity: 50,
            shadowDarkColor: Colors.black,
          ),
        ),
        // Container(
        //   margin: const EdgeInsets.all(5.0),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(15),
        //     color: Colors.red,
        //   ),
        //   child: IconButton(
        //     onPressed: () {
        //       if (context.read<GeneralState>().receiptItems.isNotEmpty) {
        //         generalDialog(
        //           title: "warning".tr,
        //           context: context,
        //           message: 'receipt_still_inprogress'.tr,
        //           onCancelText: 'exit'.tr,
        //           onOkText: 'stay'.tr,
        //           onCancel: () {
        //             if ((locator
        //                     .get<SharedStorage>()
        //                     .prefs
        //                     .read("request_visit") ??
        //                 false)) {
        //               exitDialog(
        //                 context: context,
        //                 data: data,
        //               );
        //               return false;
        //             } else {
        //               Get.back();
        //             }
        //           },
        //         );
        //       } else {
        //         if ((locator
        //                 .get<SharedStorage>()
        //                 .prefs
        //                 .read("request_visit") ??
        //             false)) {
        //           exitDialog(
        //             context: context,
        //             data: data,
        //           );
        //         } else {
        //           Get.back();
        //         }
        //       }
        //     },
        //     icon: const Icon(
        //       Icons.exit_to_app,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        Expanded(
          child: Neumorphic(
            style: const NeumorphicStyle(
              shape: NeumorphicShape.concave,
              lightSource: LightSource.top,
              surfaceIntensity: 50,
              color: Colors.white,
              shadowDarkColor: Colors.black,
            ),
            child: CustomTextField(
              name: "search",
              hintText: "search".tr,
              activated: true,
              onChanged: onChanged,
              prefixIcon: const Icon(
                Icons.search,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Consumer<GeneralState>(
            builder: (context, state, widget) => Badge(
              badgeContent: Text(
                state.receiptItems.length.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              showBadge: state.receiptItems.isNotEmpty,
              child: NeumorphicButton(
                onPressed: onTap,
                style: const NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  surfaceIntensity: 50,
                  shadowDarkColor: Colors.black,
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  color: darkBlue,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
