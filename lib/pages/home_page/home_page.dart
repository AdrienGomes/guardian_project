import 'package:flutter/material.dart';
import 'package:guardian_project/common/base_page.dart';
import 'package:guardian_project/common/widget/ripple_button.dart';
import 'package:guardian_project/pages/home_page/home_page_controller.dart';
import 'package:guardian_project/theme/theme.dart';

class HomePage extends BasePage<HomePageController> {
  HomePage({super.key}) : super(HomePageController());

  @override
  Widget getContent(BuildContext context) => AnimatedContainer(
        duration: GuardianThemeColor.animatedContainerAnimationDuration,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/angel_wings.png"),
            opacity: 0.4,
            fit: BoxFit.contain,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: SizedBox(
            width: 200,
            height: 200,
            child: BouncingStateButton(
              buttonSize: const Size(250, 250),
              onPressed: () => pageController.switchOnOffSoundMeterService(),
              getState: pageController.isSoundServiceOn,
              stateOnbuttonGradiantColor: GuardianThemeColor.buttonSatetOnGradient,
              stateOnButtonLabel: "Activated",
              stateOffButtonLabel: "Deactivated",
              stateOffbuttonGradiantColor: GuardianThemeColor.buttonSatetOffGradient,
              stateOnIcon: Icon(
                Icons.safety_check_outlined,
                color: Colors.green,
                size: 50,
                shadows: [
                  Shadow(
                    color: Colors.green.withOpacity(0.6),
                    blurRadius: 20,
                  )
                ],
              ),
              stateOffIcon: Icon(
                Icons.close,
                color: Colors.red,
                size: 50,
                shadows: [
                  Shadow(
                    color: Colors.red.withOpacity(0.6),
                    blurRadius: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Future<bool> onWillPop() => Future.value(!pageController.stateData.isBusy);
}
