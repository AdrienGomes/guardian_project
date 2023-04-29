import 'dart:async';

import 'package:guardian_project/common/base_page.dart';
import 'package:guardian_project/pages/sound_configuration/sound_configuration_page.dart';
import 'package:guardian_project/service/noise_detector_service.dart';
import 'package:guardian_project/service/sound_meter_service.dart';
import 'package:guardian_project/service_locator.dart';

/// Controller for the [SoundConfigurationPage] page
class SoundConfigurationController extends BasePageController<_StateConfigurationController> {
  static const maxEqualizerSoundVolume = 120;

  final SoundMeterService _soundMeterService = serviceLocator<SoundMeterService>();
  final NoiseLevelDetectorService _noiseLevelDetectorService = serviceLocator<NoiseLevelDetectorService>();

  /// ctor
  SoundConfigurationController() : super(_StateConfigurationController());

  @override
  void initAsync() {
    stateData._currentSubscription ??= _soundMeterService.subscribeTo(stateData._noiseReadingStreamController);
    _soundMeterService.pauseSubscription(stateData._currentSubscription.hashCode);
    _noiseLevelDetectorService.pause();
  }

  /// get a [Stream] to detect noise changes
  Stream<NoiseReading> getNoiseReadingStream() => stateData._noiseReadingStreamController.stream;

  /// get a [Stream] to detect noise detector level changes
  Stream<bool> getNoiseLevelDetectorStream() => _noiseLevelDetectorService.watcher;

  /// activate or deactivate sound meter service
  void switchOnOffSubscription() {
    _switchServices(!isSubscriptionActive());
    notifyListeners();
  }

  /// if subscription is active
  bool isSubscriptionActive() => stateData._currentSubscription?.isPaused == true;

  double getDetectionLevel() =>
      (_noiseLevelDetectorService.glidingRecordWindow.getMean() * 100) / maxEqualizerSoundVolume;

  /// turns on and off all the associated services
  void _switchServices(bool onOff) {
    if (onOff) {
      _soundMeterService.pauseSubscription(stateData._currentSubscription.hashCode);
      _noiseLevelDetectorService.pause();
    } else {
      _soundMeterService.resumeSubscription(stateData._currentSubscription.hashCode);
      _noiseLevelDetectorService.resume();
    }
  }
}

class _StateConfigurationController extends BasePageControllerState {
  final StreamController<NoiseReading> _noiseReadingStreamController = StreamController<NoiseReading>.broadcast();

  StreamSubscription<NoiseReading>? _currentSubscription;
}
