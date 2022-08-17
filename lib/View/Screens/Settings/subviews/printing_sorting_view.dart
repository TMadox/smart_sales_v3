import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Printing/create_pdf.dart';
import 'package:smart_sales/App/Resources/screen_size.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/View/Screens/Settings/Widgets/demo_cell.dart';
import 'package:smart_sales/View/Screens/Settings/settings_viewmodel.dart';

class PrintingSortingView extends StatefulWidget {
  const PrintingSortingView({Key? key}) : super(key: key);

  @override
  State<PrintingSortingView> createState() => _PrintingSortingViewState();
}

class _PrintingSortingViewState extends State<PrintingSortingView> {
  final storage = locator.get<SharedStorage>().prefs;
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
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await createPDF(
                  bContext: context,
                  receipt: context.read<GeneralState>().receiptsList.last,
                  share: false,
                );
                // Navigator.of(context).pushNamed(Routes.printingRoute);
              },
            ),
            appBar: AppBar(
              title: Text("a4_settings".tr),
            ),
            body: ProgressHUD(
              child: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      ListTile(
                        leading: IconButton(
                          onPressed: () async {
                            ProgressHUD.of(context)!.show();
                            for (var item in state.headers) {
                              await storage.setDouble(
                                item.toString() + "_x",
                                0,
                              );
                            }
                            setState(() {});
                            ProgressHUD.of(context)!.dismiss();
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                      right: storage.getDouble(
                                              state.headers[index].toString() +
                                                  "_x") ??
                                          0,
                                      child: Draggable(
                                        onDragUpdate: (details) {
                                          position = (screenWidth(context) -
                                              details.globalPosition.dx);
                                        },
                                        onDragEnd: (details) async {
                                          await storage.setDouble(
                                            state.headers[index].toString() +
                                                "_x",
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
                  );
                },
              ),
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
