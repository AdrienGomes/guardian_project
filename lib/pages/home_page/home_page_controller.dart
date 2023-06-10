import 'package:guardian_project/common/base_page.dart';
import 'package:guardian_project/service/sound_meter_service.dart';
import 'package:guardian_project/service_locator.dart';

/// ## [HomePage] controller
class HomePageController extends BaseViewPageController<_StateHomePageController> {
  HomePageController() : super(_StateHomePageController());

  /// toast service
  late final SoundMeterService _soundMeterService;

  @override
  void initAsync() {
    _soundMeterService = serviceLocator<SoundMeterService>();
  }

  /// activate or deactivate sound meter service
  void switchOnOffSoundMeterService() {
    isSoundServiceOn() ? _soundMeterService.stop() : _soundMeterService.start();
    notifyListeners();
  }

  /// ### Idea for calling
  // Future<void> startCall() async {
  //   const number = '0661984274'; //set the number here
  //   await FlutterPhoneDirectCaller.callNumber(number);
  // }

  /// get the [SoundMeterService] recording state
  bool isSoundServiceOn() => _soundMeterService.isRecording;

  @override
  void onHide() {}

  @override
  void onShow() {
    notifyListeners();
  }
}

class _StateHomePageController extends BasePageControllerState {}
