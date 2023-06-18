import 'package:guardian_project/common/base_async_state.dart';
import 'package:guardian_project/common/base_page.dart';
import 'package:guardian_project/service/workmanager_service.dart';
import 'package:guardian_project/service_locator.dart';

/// ## [HomePage] controller
class HomePageController extends BaseViewPageController<_StateHomePageController> {
  HomePageController() : super(_StateHomePageController());

  /// background task service
  late final BackgroundTaskService _backgroundTaskService;

  @override
  void initAsync() {
    _backgroundTaskService = serviceLocator<BackgroundTaskService>();
  }

  /// activate or deactivate the background task
  void activateBackgroundProtectionTask() {
    if (_backgroundTaskService.taskIsAlive) {
      _backgroundTaskService.cancelTaskAsync();
    } else {
      _backgroundTaskService.startTaskAsync();
    }
    notifyListeners();
  }

  /// ### Idea for calling
  // Future<void> startCall() async {
  //   const number = '0661984274'; //set the number here
  //   await FlutterPhoneDirectCaller.callNumber(number);
  // }

  /// get the [BackgroundTaskService] task state
  bool isProtectionOn() => _backgroundTaskService.taskIsAlive;

  @override
  void onHide() {}

  @override
  void onShow() {
    notifyListeners();
  }
}

class _StateHomePageController extends BasePageControllerState {}
