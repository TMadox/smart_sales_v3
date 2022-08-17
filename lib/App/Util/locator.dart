import 'package:get_it/get_it.dart';
import 'package:smart_sales/App/Util/device.dart';
import 'package:smart_sales/Data/Database/Commands/read_data.dart';
import 'package:smart_sales/Data/Database/Commands/save_data.dart';
import 'package:smart_sales/Data/Database/Secure/read_sensitive_data.dart';
import 'package:smart_sales/Data/Database/Secure/save_sensitive_data.dart';
import 'package:smart_sales/Data/Database/Shared/shared_storage.dart';
import 'package:smart_sales/Provider/user_state.dart';
import 'package:smart_sales/Services/Repositories/check_allowance_repo.dart';
import 'package:smart_sales/Services/Repositories/customers_repo.dart';
import 'package:smart_sales/Services/Repositories/delete_repo.dart';
import 'package:smart_sales/Services/Repositories/general_repository.dart';
import 'package:smart_sales/Services/Repositories/info_repo.dart';
import 'package:smart_sales/Services/Repositories/items_repo.dart';
import 'package:smart_sales/Services/Repositories/login_repo.dart';
import 'package:smart_sales/Services/Repositories/options_repo.dart';
import 'package:smart_sales/Services/Repositories/powers_repo.dart';
import 'package:smart_sales/Services/Repositories/request_allowance_repo.dart';
import 'package:smart_sales/Services/Repositories/upload_repo.dart';

final locator = GetIt.instance;

void inject() {
  //REPOSITORIES///
  locator.registerLazySingleton<GeneralRepository>(() => GeneralRepository());
  locator.registerLazySingleton<ItemRepo>(() => ItemRepo());
  locator.registerLazySingleton<CustomersRepo>(() => CustomersRepo());
  locator.registerLazySingleton<LoginRepo>(() => LoginRepo());
  locator.registerLazySingleton<UploadReceipts>(() => UploadReceipts());
  locator.registerLazySingleton<OptionsRepo>(() => OptionsRepo());
  locator.registerLazySingleton<InfoRepo>(() => InfoRepo());
  locator.registerLazySingleton<PowersRepo>(() => PowersRepo());
  locator.registerLazySingleton<DeleteRepo>(() => DeleteRepo());
  locator.registerLazySingleton<CheckAllowanceRepo>(() => CheckAllowanceRepo());
  locator.registerLazySingleton<RequestAllowanceRepo>(
      () => RequestAllowanceRepo());
  locator.registerLazySingleton<SharedStorage>(() => SharedStorage());
  locator.registerLazySingleton<UserState>(() => UserState());
  locator.registerLazySingleton<DeviceParam>(() => DeviceParam());
  //SECUREDATA///
  locator.registerLazySingleton<SaveSensitiveData>(() => SaveSensitiveData());
  locator.registerLazySingleton<ReadSensitiveData>(() => ReadSensitiveData());
  //DATABASE//
  locator.registerLazySingleton<SaveData>(() => SaveData());
  locator.registerLazySingleton<ReadData>(() => ReadData());
}
