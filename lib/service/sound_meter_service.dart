import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:audio_streamer/audio_streamer.dart';
import 'package:flutter/services.dart';

/// ## Sound level detector service
///
/// **Purpose : get info on sound/noise level from microphone**
///
/// To use it, subscribe to it by using the [subscribeTo] method. This will return a [StreamSubscription] with [NoiseReading] from the microphone.
///
/// The service allows to manipulate a subscription, by removing it ([removeSubscription]), stalling it ([pauseSubscription]) and resuming it ([resumeSubscription])
class SoundMeterService {
  /// true if any subscription is listening to the microphone
  bool get isRecording => _subscriptions.values.any((sub) => !sub.isPaused);

  /// interrupting timer periode. Used when asking for a pause
  static const interruptingTimerPeriode = Duration(milliseconds: 100);

  /// Map of subscriptions to this service
  final Map<int, StreamSubscription<NoiseReading>> _subscriptions = {};

  late final NoiseMeter _noiseMeter;

  /// base ctor
  SoundMeterService.init() {
    _noiseMeter = NoiseMeter(_onError);
    _updateNoiseMeter();
  }

  /// ask for a global pause of this service. allow to specify an interruption callback (checked every 100 milliseconds)
  void askForPause(Duration duration, {bool Function()? interruptionCallabck}) {
    // pause all subscriptions
    _pauseAllSubscriptions();

    // launch a timer that will resume every subscriptions once duration is over
    final pausingTimer = Timer(duration, _resumeAllSubscriptions);

    // if an interrupting callback is specified, launch a periodic timer that will resume every subscriptions accordingly to the callback result
    if (interruptionCallabck != null) {
      Timer.periodic(interruptingTimerPeriode, (timer) {
        if (interruptionCallabck.call() && pausingTimer.isActive) {
          _resumeAllSubscriptions();
          pausingTimer.cancel();
        }
      });
    }
  }

  /// Resume a single subscription (identify by its id)
  void resumeSubscription(int hashCode) {
    _subscriptions[hashCode]?.resume();
    _updateNoiseMeter();
  }

  /// pause all subscriptions
  void _resumeAllSubscriptions() {
    for (final sub in _subscriptions.values) {
      resumeSubscription(sub.hashCode);
    }
  }

  /// Pause a single subscription (identify by its id)
  void pauseSubscription(int hashCode) {
    _subscriptions[hashCode]?.pause();
    _updateNoiseMeter();
  }

  /// pause all subscriptions
  void _pauseAllSubscriptions() {
    for (final sub in _subscriptions.values) {
      pauseSubscription(sub.hashCode);
    }
  }

  /// remove a subscription
  void removeSubscription(int hashCode) {
    pauseSubscription(hashCode);
    _subscriptions.removeWhere((key, value) => key == hashCode);
  }

  /// subscribe a stream to this soundMeter service
  StreamSubscription<NoiseReading> subscribeTo(StreamController<NoiseReading> streamController,
      {void Function(NoiseReading)? onListen}) {
    var subscription = _noiseMeter.noiseStream.asBroadcastStream().listen((event) {
      onListen?.call(event);
      streamController.sink.add(event);
    });

    _addSubscription(subscription);
    return subscription;
  }

  /// according to the number of active subscriptions, update the NoiseMeter object (handling the microphone) state
  void _updateNoiseMeter() {
    if (_subscriptions.values.any((sub) => !sub.isPaused) && _noiseMeter.isStoped) {
      _noiseMeter._start();
    } else if ((_subscriptions.values.every((sub) => sub.isPaused) || _subscriptions.values.isEmpty) &&
        !_noiseMeter.isStoped) {
      _noiseMeter._stop();
    }
  }

  /// callback when an error occurs while reading data
  void _onError(Object error) {
    _pauseAllSubscriptions();
  }

  /// add a new subscription
  void _addSubscription(StreamSubscription<NoiseReading> subscription) =>
      _subscriptions[subscription.hashCode] = subscription;
}

/// Holds a decibel value for a noise level reading.
class NoiseReading {
  late double _meanDecibel, _maxDecibel;

  NoiseReading(List<double> volumes) {
    // sorted volumes such that the last element is max amplitude
    volumes.sort();

    // compute average peak-amplitude using the min and max amplitude
    double min = volumes.first;
    double max = volumes.last;
    double mean = 0.5 * (min.abs() + max.abs());

    // max amplitude is 2^15
    double maxAmp = pow(2, 15) + 0.0;

    _maxDecibel = 20 * log(maxAmp * max) * log10e;
    _meanDecibel = 20 * log(maxAmp * mean) * log10e;
  }

  /// Maximum measured decibel reading.
  double get maxDecibel => _maxDecibel;

  /// Mean decibel across readings.
  double get meanDecibel => _meanDecibel;

  @override
  String toString() => '$runtimeType - meanDecibel: $meanDecibel, maxDecibel: $maxDecibel';
}

/// A [NoiseMeter] provides continous access to noise reading via the [noiseStream].
class NoiseMeter {
  final AudioStreamer _streamer = AudioStreamer();
  late StreamController<NoiseReading> _controller;
  Stream<NoiseReading>? _stream;

  bool isStoped = true;

  // The error callback function.
  Function? onError;

  /// Create a [NoiseMeter].
  /// The [onError] callback must be of type `void Function(Object error)`
  /// or `void Function(Object error, StackTrace)`.
  NoiseMeter([this.onError]);

  /// The rate at which the audio is sampled
  static Future<int> get sampleRate async => await AudioStreamer.currSampleRate;

  /// The stream of noise readings.
  Stream<NoiseReading> get noiseStream {
    if (_stream == null) {
      _controller = StreamController<NoiseReading>.broadcast(onCancel: _stop);
      _stream = (onError != null) ? _controller.stream.handleError(onError!) : _controller.stream;
    }
    return _stream!;
  }

  /// Whenever an array of PCM data comes in,
  /// they are converted to a [NoiseReading],
  /// and then send out via the stream
  void _onAudio(List<double> buffer) => _controller.add(NoiseReading(buffer));

  void _onInternalError(PlatformException e) {
    _stream = null;
    _controller.addError(e);
  }

  /// Start noise monitoring.
  /// This will trigger a permission request
  /// if it hasn't yet been granted
  void _start() async {
    try {
      _streamer.start(_onAudio, _onInternalError);
      isStoped = false;
    } catch (error) {
      //print(error);
    }
  }

  /// Stop noise monitoring
  void _stop() async {
    await _streamer.stop();
    isStoped = true;
  }
}
