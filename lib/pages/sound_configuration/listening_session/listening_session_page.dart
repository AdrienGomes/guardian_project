import 'package:flutter/material.dart';
import 'package:guardian_project/common/base_page.dart';
import 'package:guardian_project/common/widget/listening_session_widget.dart';
import 'package:guardian_project/pages/sound_configuration/listening_session/listening_session_controller.dart';

/// ## Page : listening sessions
///
/// This page shows every listening profiles and allow to edit them
///
/// *See [BasePopingPage]*
class ListeningSessionPage extends BasePopingPage<ListeningSessionPageController> {
  ListeningSessionPage({super.key}) : super(ListeningSessionPageController(), "Listening Sessions");

  @override
  Widget getContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
      child: Stack(
        children: [
          ListView.builder(
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListeningSessionWidget(
                listeningSession: pageController.stateData.listeningSessions.elementAt(index),
                onActiveListeningSession: () => pageController.setActiveListeningSession(index),
                isActive: pageController.stateData.listeningSessions[index] ==
                    pageController.stateData.activeListeningSession,
              ),
            ),
            itemCount: pageController.stateData.listeningSessions.length,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: FloatingActionButton(
                onPressed: () async => await pageController.addListeningSession(),
                elevation: 10,
                child: const Icon(Icons.add),
              ),
            ),
          )
        ],
      ),
    );
  }
}
