import 'package:flutter/material.dart';
import 'package:guardian_project/common/base_page.dart';
import 'package:guardian_project/common/widget/bouncing_button.dart';
import 'package:guardian_project/pages/home_page/home_page_controller.dart';
import 'package:guardian_project/theme/theme.dart';

class HomePage extends BasePage<HomePageController> {
  HomePage({super.key}) : super(HomePageController());

  @override
  Widget getContent(BuildContext context) => AnimatedContainer(
        duration: GuardianThemeColor.animatedContainerAnimationDuration,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: pageController.isSoundServiceOn()
              ? [
                  GuardianThemeColor.buttonSatetOnGradient.colors.first.withOpacity(0.45),
                  GuardianThemeColor.buttonSatetOnGradient.colors.last.withOpacity(0.0),
                ]
              : [
                  GuardianThemeColor.buttonSatetOffGradient.colors.first.withOpacity(0.45),
                  GuardianThemeColor.buttonSatetOffGradient.colors.last.withOpacity(0.0),
                ],
        )),
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: SizedBox(
            width: 200,
            height: 200,
            child: BouncingStateButton(
              isCircularButton: true,
              buttonSize: const Size(250, 250),
              onPressed: () => pageController.switchOnOffSoundMeterService(),
              getState: pageController.isSoundServiceOn,
              stateOnbuttonGradiantColor: GuardianThemeColor.buttonSatetOnGradient,
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
