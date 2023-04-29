import 'package:flutter/material.dart';
import 'package:guardian_project/common/base_page.dart';
import 'package:guardian_project/common/widget/sound_level_widget.dart';
import 'package:guardian_project/pages/sound_configuration/sound_configuration_controller.dart';

/// **Page : SoundConfiguration**
///
/// Widget that create the sound configuration/visualisation page
///
/// *See [BasePage]*
class SoundConfigurationPage extends BasePage<SoundConfigurationController> {
  SoundConfigurationPage({super.key}) : super(SoundConfigurationController());

  @override
  Widget getContent(BuildContext context) => Container(
        padding: const EdgeInsets.all(50),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: StreamSoundLevelViewer(
                  getLevelDetectorMeanValue: () => pageController.getDetectionLevel(),
                  noiseLevelDetectorStream: pageController.getNoiseLevelDetectorStream(),
                  noiseStream: pageController.getNoiseReadingStream(),
                  maxVolume: SoundConfigurationController.maxEqualizerSoundVolume,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FloatingActionButton(
                  onPressed: pageController.switchOnOffSubscription,
                  child: Icon(pageController.isSubscriptionActive() ? Icons.mic_none_outlined : Icons.stop)),
            ],
          ),
        ),
      );

  @override
  Future<bool> onWillPop() => Future.value(!pageController.stateData.isBusy);
}
