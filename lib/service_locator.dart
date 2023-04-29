import 'package:get_it/get_it.dart';
import 'package:guardian_project/main.dart';
import 'package:guardian_project/service/noise_detector_service.dart';
import 'package:guardian_project/service/sound_meter_service.dart';
import 'package:guardian_project/service/toast_service.dart';
import 'package:guardian_project/service/workmanager_service.dart';

/// global variable for service locator
GetIt serviceLocator = GetIt.instance;

/// class to use Dependance injection
///
/// Based on [GetIt] module
class ServiceLocator {
  /// base ctor
  ServiceLocator.init() {
    _initServices();
  }

  void _initServices() {
    // register sound meter service
    final soundMeterServiceInstance = SoundMeterService.init();
    serviceLocator.registerSingleton(soundMeterServiceInstance);

    // register toast service
    final toastServiceInstance = ToastService.init(navigatorKey);
    serviceLocator.registerSingleton(toastServiceInstance);

    // register bacground task manager Service
    serviceLocator.registerSingleton(BackgroundTaskService.init(toastServiceInstance));

    // register sound level detector service
    serviceLocator.registerFactory(() => NoiseLevelDetectorService.init(soundMeterServiceInstance));
  }
}
