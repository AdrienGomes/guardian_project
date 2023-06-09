import 'package:get_it/get_it.dart';
import 'package:guardian_project/bootstrap/base_bootstrap.dart';
import 'package:guardian_project/bootstrap/bootstrap_manager.dart';
import 'package:guardian_project/bootstrap/db_initializer_bootstrap.dart';
import 'package:guardian_project/main.dart';
import 'package:guardian_project/service/db_client_service.dart';
import 'package:guardian_project/service/sound_detector_service.dart';
import 'package:guardian_project/service/sound_meter_service.dart';
import 'package:guardian_project/service/toast_service.dart';
import 'package:guardian_project/service/voice_recognition_service.dart';
import 'package:guardian_project/service/workmanager_service.dart';
import 'package:permission_handler/permission_handler.dart';

/// global variable for service locator
GetIt serviceLocator = GetIt.instance;

/// class to use Dependance injection
///
/// Based on [GetIt] module
class ServiceLocator {
  /// base ctor
  ServiceLocator.init() {
    _initServices();
    _registerBootStrapServices();
    _handleRequiredPermission();
  }

  void _initServices() {
    // ---------------------------------------------------------
    // Singleton services
    // ---------------------------------------------------------

    // register sound meter service
    final soundMeterServiceInstance = SoundMeterService.init();
    serviceLocator.registerSingleton(soundMeterServiceInstance);
    // register toast service
    final toastServiceInstance = ToastService.init(navigatorKey);
    serviceLocator.registerSingleton(toastServiceInstance);
    // register voice recognition service
    serviceLocator.registerSingleton(VoiceRecognitionService.init(toastServiceInstance, soundMeterServiceInstance));
    // register bacground task manager Service
    serviceLocator.registerSingleton(BackgroundTaskService.init(toastServiceInstance));
    // register db service
    serviceLocator.registerSingleton(DbClientService.init());

    // ---------------------------------------------------------
    // Factory services
    // ---------------------------------------------------------

    // register sound level detector service
    serviceLocator.registerFactory(() => SoundLevelDetectorService.init(soundMeterServiceInstance));
  }

  /// register [BaseBootStarp] services
  void _registerBootStrapServices() {
    /// list of bootstrap services
    final bootstrapServices = [DbInitializerBootstrap.init()];

    /// register DB bootstraper
    serviceLocator.registerFactory<BootStrapManager>(() => BootStrapManager.init(bootstrapServices));
  }

  /// handle all the required permission
  ///
  /// TODO : should move elsewhere to be triggered every time the app is launched
  Future<void> _handleRequiredPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.audio,
      Permission.contacts,
      Permission.activityRecognition,
      Permission.microphone,
      Permission.phone,
    ].request();

    // retry to ask for permission
    statuses.forEach((key, value) async {
      if (value.isDenied) {
        await key.request();
      }
    });
  }
}
