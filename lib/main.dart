import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:smart_sales/App/Resources/localization_manager.dart';
import 'package:smart_sales/App/Resources/theme_manager.dart';
import 'package:smart_sales/App/Util/bindings.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/App/Util/routing.dart';
import 'package:smart_sales/App/Util/scroll_behavior.dart';
import 'package:smart_sales/App/Util/locator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_sales/Provider/expenses_state.dart';
import 'package:smart_sales/Provider/groups_state.dart';
import 'package:smart_sales/Provider/kinds_state.dart';
import 'package:smart_sales/Provider/mow_state.dart';
import 'package:smart_sales/Provider/stor_state.dart';
import 'package:smart_sales/View/Common/Widgets/Common/error_widget.dart';
import 'package:smart_sales/View/Screens/Items/items_viewmodel.dart';
import 'package:smart_sales/Provider/clients_state.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_sales/Provider/info_state.dart';
import 'package:smart_sales/Provider/options_state.dart';
import 'package:smart_sales/Provider/powers_state.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/View/Screens/Documents/document_viewmodel.dart';
import 'package:smart_sales/View/Screens/Login/login_viewmodel.dart';
import 'package:smart_sales/View/Screens/Settings/settings_viewmodel.dart';
import 'package:smart_sales/View/Screens/Splash/splash_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  inject();
  await GetStorage.init();
  // await GetStorage().erase();
  await locator.get<DeviceParam>().getDeviceId();
  await locator.get<DeviceParam>().getDocumentsPath();
  final prefs = GetStorage();
  if (prefs.read("ip_password") == null) {
    await prefs.write("ip_password", "200");
    await prefs.write("user_id", "31");
    await prefs.write("ip_address", "sky3m.duckdns.org");
  }
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
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
        ChangeNotifierProvider(create: (_) => ClientsState()),
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => SettingsViewmodel()),
        ChangeNotifierProvider(create: (_) => SplashViewmodel()),
        ChangeNotifierProvider(create: (_) => OptionsState()),
        ChangeNotifierProvider(create: (_) => InfoState()),
        ChangeNotifierProvider(create: (_) => PowersState()),
        ChangeNotifierProvider(create: (_) => LoginViewmodel()),
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
    precacheImage(const AssetImage("assets/cashier.png"), context);
    return GetMaterialApp(
      theme: ThemeManger.lightTheme,
      scrollBehavior: MyCustomScrollBehavior(),
      initialBinding: AppBindings(),
      localizationsDelegates: const [
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
        FormBuilderLocalizations.delegate,
      ],
      translations: LocalizationManager(),
      locale: Locale(GetStorage().read("language") ?? "ar"),
      supportedLocales: LocalizationManager.locales,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      onGenerateRoute: appRouter.generateRoute,
      builder: EasyLoading.init(
        builder: ((context, child) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return CustomError(
              errorDetails: errorDetails,
              key: null,
            );
          };
          return ResponsiveWrapper.builder(
            child,
            maxWidth: 2024,
            minWidth: 480,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.autoScale(600, scaleFactor: 0.75),
            ],
          );
        }),
      ),
    );
  }
}
