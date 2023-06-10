import 'package:flutter/material.dart';
import 'package:guardian_project/common/base_page.dart';
import 'package:guardian_project/common/widget/ripple_button.dart';
import 'package:guardian_project/intl.dart';
import 'package:guardian_project/pages/home_page/home_page_controller.dart';
import 'package:guardian_project/theme/guardian_theme_color.dart';

/// ## Page : Home Page
///
/// This page shows a button that enable the guardian background service
///
/// *See [BasePage]*
class HomePage extends BasePage<HomePageController> {
  HomePage({super.key}) : super(HomePageController());

  static const _animatedContainerAnimationDuration = Duration(milliseconds: 300);

  @override
  Widget getContent(BuildContext context) => AnimatedContainer(
        duration: _animatedContainerAnimationDuration,
        //  TODO: to remove : (A test to diaply images)
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
              onPressed: pageController.activateBackgroundProtectionTask,
              getState: pageController.isProtectionOn,
              stateOnbuttonGradiantColor: GuardianThemeColor.buttonSatetOnGradient,
              stateOnButtonLabel: tr.home_page_button_state_on_label,
              stateOffButtonLabel: tr.home_page_button_state_off_label,
              stateOffbuttonGradiantColor: GuardianThemeColor.buttonSatetOffGradient,
              stateOnIcon: const Icon(
                Icons.safety_check_outlined,
                size: 50,
              ),
              stateOffIcon: const Icon(
                Icons.close,
                size: 50,
              ),
            ),
          ),
        ),
      );
}
