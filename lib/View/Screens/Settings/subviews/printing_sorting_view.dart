import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/View/Screens/Settings/Widgets/demo_cell.dart';
import 'package:smart_sales/View/Screens/Settings/settings_viewmodel.dart';

class PrintingSortingView extends StatefulWidget {
  const PrintingSortingView({Key? key}) : super(key: key);

  @override
  State<PrintingSortingView> createState() => _PrintingSortingViewState();
}

class _PrintingSortingViewState extends State<PrintingSortingView> {
  final storage = GetStorage();
  double position = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewmodel>(
      builder: (context, state, child) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text("a4_settings".tr),
            ),
            body: Column(
              children: [
                ListTile(
                  leading: IconButton(
                    onPressed: () async {
                      EasyLoading.show();
                      for (var item in state.headers) {
                        await storage.write(
                          item.toString() + "_x",
                          0,
                        );
                      }
                      setState(() {});
                      EasyLoading.dismiss();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.green,
                    ),
                  ),
                  title: Text("postion_elements".tr),
                  trailing: Text("position_instructions".tr),
                ),
                Expanded(
                  child: ReorderableListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Card(
                        key: ValueKey(state.cells[index]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            state.cells[index].tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: 8,
                    onReorder: (oldIndex, newIndex) {
                      state.switchCellPosition(
                          oldIndex: oldIndex, newIndex: newIndex);
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: ReorderableListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Card(
                        key: ValueKey(state.headers[index]),
                        child: SizedBox(
                          height: screenHeight(context) * 0.1,
                          child: Stack(
                            children: [
                              Positioned(
                                right: storage.read(
                                        state.headers[index].toString() +
                                            "_x") ??
                                    0,
                                child: Draggable(
                                  onDragUpdate: (details) {
                                    position = (screenWidth(context) -
                                        details.globalPosition.dx);
                                  },
                                  onDragEnd: (details) async {
                                    await storage.write(
                                      state.headers[index].toString() + "_x",
                                      position,
                                    );
                                    setState(() {});
                                  },
                                  child: Card(
                                    child: DemoCell(
                                      name: state.headers[index].tr,
                                    ),
                                  ),
                                  feedback: Material(
                                    child: DemoCell(
                                      name: state.headers[index].tr,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    onReorder: (int oldIndex, int newIndex) async {
                      state.switchHeaderPosition(
                        oldIndex: oldIndex,
                        newIndex: newIndex,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

extension SwappableList<E> on List<E> {
  void swap(int first, int second) {
    final temp = this[first];
    this[first] = this[second];
    this[second] = temp;
  }
}
