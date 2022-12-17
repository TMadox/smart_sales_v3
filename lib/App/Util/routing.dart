import 'package:flutter/material.dart';
import 'package:smart_sales/Data/Models/client.dart';
import 'package:smart_sales/View/Screens/Cashier/cashier_view.dart';
import 'package:smart_sales/View/Screens/Kinds/kinds_view.dart';
import 'package:smart_sales/View/Screens/Clients/clients_screen.dart';
import 'package:smart_sales/View/Screens/Home/home_view.dart';
import 'package:smart_sales/View/Screens/Details/details_view.dart';
import 'package:smart_sales/View/Screens/Settings/settings_view.dart';
import 'package:smart_sales/View/Screens/Settings/subviews/cashier_settings_view.dart';
import 'package:smart_sales/View/Screens/Settings/subviews/names_settings_view.dart';
import 'package:smart_sales/View/Screens/Settings/subviews/operations_settings_view.dart';
import 'package:smart_sales/View/Screens/Settings/subviews/printing_settings_view.dart';
import 'package:smart_sales/View/Screens/Settings/subviews/server_settings_view.dart';
import 'package:smart_sales/View/Screens/Splash/splash_screen.dart';
import 'package:smart_sales/View/Screens/Stors/stors_view.dart';

class Routes {
  static const String splashRoute = '/';
  static const String homeRoute = '/home';
  static const String documentsRoute = '/documents';
  static const String clientsRoute = '/clients';
  static const String recieptsRoute = '/reciepts';
  static const String itemsRoute = '/items';
  static const String settingsRoute = '/settings';
  static const String loginRoute = '/login';
  static const String printingSettingsRoute = '/printing_settings';
  static const String printingRoute = '/printing';
  static const String namesRoute = '/receipt_names';
  static const String inventoryRoute = '/inventory';
  static const String operationsSettingsRoute = '/operations_settings';
  static const String serverSettingsRoute = '/server_settings';
  static const String cashierSettingsRoute = '/cashier_settings';
  static const String expensesRoute = '/expenses_route';
  static const String cashierRoute = '/cashierRoute';
  static const String storsRoute = '/storsRoute';
  static const String kindsRoute = '/kindsRoute';
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const SplashScreen();
        });
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const HomeScreen();
        });
      case Routes.namesRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const ReceiptNamesView();
        });
      case Routes.printingSettingsRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const ElementsSettingsView();
        });
      // case Routes.inventoryRoute:
      //   return MaterialPageRoute(builder: (BuildContext context) {
      //     return const InventoryView();
      //   });
      case Routes.settingsRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const SettingsView();
        });
      case Routes.operationsSettingsRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const OperationsSettingsView();
        });
      // case Routes.printingRoute:
      //   return MaterialPageRoute(builder: (BuildContext context) {
      //     return const PrintingView();
      //   });
      case Routes.serverSettingsRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const ServerSettingsView();
        });
      case Routes.cashierSettingsRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const CashierSettingsView();
        });
      case Routes.storsRoute:
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return StorsView(
              canTap: (settings.arguments as StorsView).canTap,
              canPushReplace: (settings.arguments as StorsView).canPushReplace,
              choosingSourceStor:
                  (settings.arguments as StorsView).choosingSourceStor,
            );
          },
        );
      case Routes.cashierRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return CashierView(
            client: settings.arguments as Client,
          );
        });
      case Routes.kindsRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return const KindsView();
        });
      case 'clients':
        return MaterialPageRoute(builder: (BuildContext context) {
          return ClientsScreen(
            canPushReplace:
                (settings.arguments as ClientsScreen).canPushReplace,
            sectionType: (settings.arguments as ClientsScreen).sectionType,
            canTap: (settings.arguments as ClientsScreen).canTap,
          );
        });
      // case 'reciepts':
      //   return MaterialPageRoute(builder: (BuildContext context) {
      //     return const OperationsView();
      //   });
      // case Routes.documentsRoute:
      //   return MaterialPageRoute(builder: (BuildContext context) {
      //     return DocumentsScreen(
      //       sectionNo: settings.arguments as int, entity: null,
      //     );
      //   });

      case "receiptDetails":
        return MaterialPageRoute(builder: (BuildContext context) {
          return DetailsView(
            receipt: settings.arguments as Map,
          );
        });
      // case 'ReceiptCreation':
      //   return MaterialPageRoute(
      //     builder: (BuildContext context) {
      //       return ReceiptScreen(
      //         entity: settings.arguments as Entity,
      //       );
      //     },
      //   );
      // case "receiptEdit":
      //   return MaterialPageRoute(builder: (BuildContext context) {
      //     return ReceiptEditScreen(
      //       entity: settings.arguments as Client,
      //     );
      //   });
      // case Routes.itemsRoute:
      //   return MaterialPageRoute(builder: (BuildContext context) {
      //     return ItemsView(
      //       canTap: settings.arguments as bool,
      //     );
      //   });
      case 'splash':
        return MaterialPageRoute(builder: (BuildContext context) {
          return const SplashScreen();
        });
    }
    return null;
  }
}
