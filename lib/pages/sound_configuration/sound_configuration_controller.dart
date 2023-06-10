import 'dart:async';

import 'package:guardian_project/common/base_page.dart';
import 'package:guardian_project/intl.dart';
import 'package:guardian_project/pages/sound_configuration/sound_configuration_page.dart';
import 'package:guardian_project/service/sound_detector_service.dart';
import 'package:guardian_project/service/sound_meter_service.dart';
import 'package:guardian_project/service/toast_service.dart';
import 'package:guardian_project/service/voice_recognition_service.dart';
import 'package:guardian_project/service_locator.dart';

/// Controller for the [SoundConfigurationPage] page
class SoundConfigurationController extends BaseViewPageController<_StateConfigurationController> {
  /// Maximum volume that could be displayed
  static const maxEqualizerSoundVolume = 120;

  final SoundMeterService _soundMeterService = serviceLocator<SoundMeterService>();
  final SoundLevelDetectorService _noiseLevelDetectorService = serviceLocator<SoundLevelDetectorService>();
  final VoiceRecognitionService _voiceRecognitionService = serviceLocator<VoiceRecognitionService>();
  final ToastService _toastService = serviceLocator<ToastService>();

  /// ctor
  SoundConfigurationController() : super(_StateConfigurationController());

  @override
  void initAsync() {
    // init [SoundMeterService] subscription
    stateData._currentNoiseReadingSubscription ??=
        _soundMeterService.subscribeTo(stateData._noiseReadingStreamController);

    // pause both [SoundMeterService] and [SoundLevelDetectorService]
    _soundMeterService.pauseSubscription(stateData._currentNoiseReadingSubscription.hashCode);
    _noiseLevelDetectorService.pause();

    // bind the [VoiceRecognitionService] on the output of the [SoundLevelDetectorService]
    final noiseLevelStreamController = StreamController<bool>.broadcast()
      ..addStream(_noiseLevelDetectorService.watcher);
    noiseLevelStreamController.stream.listen((event) {
      if (event) _voiceRecognitionService.addListeningSession(_buildListeningSession());
    });

    stateData._noiseLevelDetectorStreamController = noiseLevelStreamController;
  }

  /// Activate or deactivate any [SoundMeterService] subscriptions
  void switchOnOffSubscription() {
    _switchServices(!isSubscriptionActive());
    notifyListeners();
  }

  /// Tells if the NoiseReading subscription is active
  bool isSubscriptionActive() => stateData._currentNoiseReadingSubscription?.isPaused == true;

  /// Get the noise detector mean value
  double getDetectionLevel() =>
      (_noiseLevelDetectorService.meanValue.isNaN || _noiseLevelDetectorService.meanValue.isInfinite)
          ? 0
          : _noiseLevelDetectorService.meanValue;

  /// Turns on and off all the services homed by this controller
  void _switchServices(bool turnOff) {
    if (turnOff) {
      _soundMeterService.pauseSubscription(stateData._currentNoiseReadingSubscription.hashCode);
      _noiseLevelDetectorService.pause();
    } else {
      _soundMeterService.resumeSubscription(stateData._currentNoiseReadingSubscription.hashCode);
      _noiseLevelDetectorService.resume();
    }
  }

  /// Build a listening sessions
  ListeningSession _buildListeningSession() => ListeningSession(
      hotSentence: stateData._hotSentence,
      onRecognizedSentence: () {
        _toastService.showToast(tr.sound_configuration_hot_sentence_recognized_toast_label(stateData._hotSentence));
        // turn off services when hot sentence recognized
        _switchServices(true);
      });

  /// update hotSentence
  void updateHotSentence(String newSentence) => stateData._hotSentence = newSentence;

  @override
  void onHide() => _switchServices(true);

  @override
  void onShow() {}
}

class _StateConfigurationController extends BasePageControllerState {
  /// [StreamController] used to subscribe to [SoundMeterService]
  final StreamController<NoiseReading> _noiseReadingStreamController = StreamController<NoiseReading>.broadcast();

  /// Noise reaing [Stream] to listen to the [SoundMeterService]
  Stream<NoiseReading> get noiseReadingStream => _noiseReadingStreamController.stream;

  /// current [StreamSubscription] from subscribing [_noiseReadingStreamController] to the [SoundMeterService]
  StreamSubscription<NoiseReading>? _currentNoiseReadingSubscription;

  /// [SoundLevelDetectorService] watcher ([SoundLevelDetectorService.watcher])
  Stream<bool> get noiseLevelDetectorStream => _noiseLevelDetectorStreamController.stream;
  late final StreamController<bool> _noiseLevelDetectorStreamController;

  /// the sentence to be recognized during listening session
  String get hotSentence => _hotSentence;
  String _hotSentence = tr.sound_controller_page_default_hot_sentence;
}
