import 'package:flutter/material.dart';
import 'package:guardian_project/common/base_page.dart';
import 'package:guardian_project/pages/listening_profile/listening_profile_list_widget.dart';
import 'package:guardian_project/pages/listening_profile/listening_profile_widget.dart';
import 'package:guardian_project/intl.dart';
import 'package:guardian_project/pages/listening_profile/listening_profiles_controller.dart';

/// ## Page : listening sessions
///
/// This page shows every listening profiles and allow to edit them
///
/// *See [BasePopingPage]*
class ListeningProfilesPage extends BaseViewPage<ListeningProfilesPageController> {
  ListeningProfilesPage({super.key}) : super(ListeningProfilesPageController());

  @override
  Widget getContent(BuildContext context) {
    return pageController.stateData.isBusy
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
            child: Stack(
              children: [
                SlidingAnimatedList(
                  initialCount: pageController.stateData.listeningSessions.length,
                  onDeleteItem: (index) => pageController.removeListeningProfile(index),
                  childBuilder: (index) => ListeningProfileWidget(
                    listeningSession: pageController.stateData.listeningSessions.elementAt(index),
                    onActiveListeningSession: () => pageController.setActiveListeningSession(index),
                    isActive: pageController.stateData.listeningSessions[index] ==
                        pageController.stateData.activeListeningSession,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: FloatingActionButton.extended(
                      isExtended: true,
                      onPressed: () async => await pageController.addListeningProfile(),
                      elevation: 10,
                      label: Text(
                        tr.common_new_profile_label,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      icon: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
