import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:unique_identifier/unique_identifier.dart';

class DeviceParam {
  String? deviceId;
  String? documentsPath;
  Future<void> getDeviceId() async {
    try {
      if (Platform.isWindows || Platform.isMacOS || kIsWeb) {
        deviceId = await PlatformDeviceId.getDeviceId;
      } else {
        deviceId = await UniqueIdentifier.serial;
      }
    } catch (e) {
      deviceId = "لم يتم التعرف علي الجهاز";
    }
  }

  Future<void> getDocumentsPath() async {
    if (!kIsWeb) {
      documentsPath = (await getApplicationDocumentsDirectory()).path;
    }
  }
}
