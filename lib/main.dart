import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smart_sales/App/Resources/localization_manager.dart';
import 'package:smart_sales/App/Resources/theme_manager.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/App/Util/scroll_behavior.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Provider/expenses_state.dart';
import 'package:smart_sales/Provider/groups_state.dart';
import 'package:smart_sales/Provider/kinds_state.dart';
import 'package:smart_sales/Provider/mow_state.dart';
import 'package:smart_sales/Provider/stor_state.dart';
import 'package:smart_sales/View/Screens/Inventory/inventory_viewmodel.dart';
import 'package:smart_sales/View/Screens/Items/items_viewmodel.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_sales/Provider/info_state.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/Provider/general_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Documents/document_viewmodel.dart';
import 'package:smart_sales/View/Screens/Login/login_viewmodel.dart';
import 'package:smart_sales/View/Screens/Receipts/receipt_viewmodel.dart';
import 'package:smart_sales/View/Screens/Settings/settings_viewmodel.dart';
import 'package:smart_sales/View/Screens/Splash/splash_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  inject();
  await locator.get<SharedStorage>().init();
  await locator.get<DeviceParam>().getDeviceId();
  await locator.get<DeviceParam>().getDocumentsPath();
  final prefs = locator.get<SharedStorage>().prefs;
  // prefs.clear();
  if (prefs.getString("ip_password") == null) {
    await prefs.setString("ip_password", "200");
    await prefs.setString("user_id", "31");
    await prefs.setString("ip_address", "sky3m.duckdns.org");
  }
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 30.0
    ..radius = 10.0
    ..progressColor = Colors.green
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.green
    ..textColor = Colors.green
    ..maskColor = Colors.grey.withOpacity(0.3)
    ..maskType = EasyLoadingMaskType.custom
    ..userInteractions = false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DocumentsViewmodel()),
        ChangeNotifierProvider(create: (_) => ItemsViewmodel()),
        ChangeNotifierProvider(create: (_) => GeneralState()),
        ChangeNotifierProvider(create: (_) => ClientsState()),
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => SettingsViewmodel()),
        ChangeNotifierProvider(create: (_) => InventoryViewmodel()),
        ChangeNotifierProvider(create: (_) => SplashViewmodel()),
        ChangeNotifierProvider(create: (_) => OptionsState()),
        ChangeNotifierProvider(create: (_) => InfoState()),
        ChangeNotifierProvider(create: (_) => PowersState()),
        ChangeNotifierProvider(create: (_) => LoginViewmodel()),
        ChangeNotifierProvider(create: (_) => ReceiptViewmodel()),
        // ChangeNotifierProvider(create: (_) => PrintingViewmodel()),
        ChangeNotifierProvider(create: (_) => StoreState()),
        ChangeNotifierProvider(create: (_) => KindsState()),
        ChangeNotifierProvider(create: (_) => MowState()),
        ChangeNotifierProvider(create: (_) => GroupsState()),
        ChangeNotifierProvider(create: (_) => ExpenseState()),
      ],
      child: MyApp(
        appRouter: AppRouter(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({Key? key, required this.appRouter}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    return GetMaterialApp(
      theme: ThemeManger.lightTheme,
      scrollBehavior: MyCustomScrollBehavior(),
      localizationsDelegates: const [
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
        FormBuilderLocalizations.delegate,
      ],
      translations: LocalizationManager(),
      locale: Locale(
          locator.get<SharedStorage>().prefs.getString("language") ?? "ar"),
      supportedLocales: LocalizationManager.locales,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      onGenerateRoute: appRouter.generateRoute,
      builder: EasyLoading.init(
        builder: ((context, child) {
          return MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        }),
      ),
    );
  }
}
