
import 'shared_platform_interface.dart';

class Shared {
  Future<String?> getPlatformVersion() {
    return SharedPlatform.instance.getPlatformVersion();
  }
}
