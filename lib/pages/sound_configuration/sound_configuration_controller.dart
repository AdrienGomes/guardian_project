import 'dart:async';

import 'package:guardian_project/common/base_page.dart';
import 'package:guardian_project/pages/sound_configuration/sound_configuration_page.dart';
import 'package:guardian_project/service/noise_detector_service.dart';
import 'package:guardian_project/service/sound_meter_service.dart';
import 'package:guardian_project/service_locator.dart';

/// Controller for the [SoundConfigurationPage] page
class SoundConfigurationController extends BaseViewPageController<_StateConfigurationController> {
  static const maxEqualizerSoundVolume = 120;

  final NoiseMeterService _soundMeterService = serviceLocator<NoiseMeterService>();
  final NoiseLevelDetectorService _noiseLevelDetectorService = serviceLocator<NoiseLevelDetectorService>();

  /// ctor
  SoundConfigurationController() : super(_StateConfigurationController());

  @override
  void initAsync() {
    stateData._currentNoiseReadingSubscription ??=
        _soundMeterService.subscribeTo(stateData._noiseReadingStreamController);
    _soundMeterService.pauseSubscription(stateData._currentNoiseReadingSubscription.hashCode);
    _noiseLevelDetectorService.pause();

    stateData._noiseLevelDetectorStream = _noiseLevelDetectorService.watcher;
  }

  /// activate or deactivate sound meter service
  void switchOnOffSubscription() {
    _switchServices(!isSubscriptionActive());
    notifyListeners();
  }

  /// if noise reading subscription is active
  bool isSubscriptionActive() => stateData._currentNoiseReadingSubscription?.isPaused == true;

  /// get the noise detector mean value
  double getDetectionLevel() => _noiseLevelDetectorService.meanValue;

  /// turns on and off all the associated services
  void _switchServices(bool turnOff) {
    if (turnOff) {
      _soundMeterService.pauseSubscription(stateData._currentNoiseReadingSubscription.hashCode);
      _noiseLevelDetectorService.pause();
    } else {
      _soundMeterService.resumeSubscription(stateData._currentNoiseReadingSubscription.hashCode);
      _noiseLevelDetectorService.resume();
    }
  }

  @override
  void onHide() => _switchServices(true);

  @override
  void onShow() {}
}

class _StateConfigurationController extends BasePageControllerState {
  /// [StreamController] used to subscribe to [NoiseMeterService]
  final StreamController<NoiseReading> _noiseReadingStreamController = StreamController<NoiseReading>.broadcast();

  /// current [StreamSubscription] from subscribing [_noiseReadingStreamController] to the [NoiseMeterService]
  StreamSubscription<NoiseReading>? _currentNoiseReadingSubscription;

  /// Noise reaing [Stream] to listen to the [NoiseMeterService]
  Stream<NoiseReading> get noiseReadingStream => _noiseReadingStreamController.stream;

  /// [NoiseLevelDetectorService] watcher ([NoiseLevelDetectorService.watcher])
  Stream<bool> get noiseLevelDetectorStream => _noiseLevelDetectorStream;
  late final Stream<bool> _noiseLevelDetectorStream;
}
