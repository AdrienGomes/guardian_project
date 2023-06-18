import 'package:guardian_project/bootstrap/base_bootstrap.dart';

/// Allow to run every [BaseBootStarp] services
class BootStrapManager {
  BootStrapManager.init(this._bootstrapServices);

  /// list of [BaseBootStarp] services
  final List<BaseBootStarp> _bootstrapServices;

  /// triggers every [BaseBootStarp] methods
  Future<void> onBoot() async {
    for (var bs in _bootstrapServices) {
      await bs.run();
    }
  }
}
