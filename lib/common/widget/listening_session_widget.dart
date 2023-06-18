import 'package:flutter/material.dart';
import 'package:guardian_project/common/widget/theme/guardian_theme_color.dart';
import 'package:guardian_project/model/model_object/listening_session_model_object.dart';

/// build a listening session's [ListTile]
///
/// TODO : upgrade that widget to manipulate both hotwords and listening sessions
class ListeningSessionWidget extends StatefulWidget {
  /// true if this is the active listening session
  final bool isActive;

  /// the listening session
  final ListeningSessionModelObject listeningSession;

  /// callback when a listening session gets activated
  final void Function() onActiveListeningSession;

  /// ctor
  const ListeningSessionWidget(
      {super.key, required this.listeningSession, required this.onActiveListeningSession, this.isActive = false});

  @override
  State<StatefulWidget> createState() => _StateListeningSessionWidget();
}

class _StateListeningSessionWidget extends State<ListeningSessionWidget> {
  @override
  Widget build(BuildContext context) => Card(
        elevation: widget.isActive ? 10 : 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          title: Text(
            widget.listeningSession.label ?? "",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            widget.listeningSession.hotWords?.map((hw) => hw.value).toList().join(' - ') ?? "",
            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            softWrap: true,
            overflow: TextOverflow.fade,
          ),
          trailing: widget.isActive
              ? const Icon(
                  Icons.check_box_outlined,
                  color: GuardianThemeColor.stateOnColor,
                )
              : null,
          onTap: widget.onActiveListeningSession,
          selected: widget.isActive,
        ),
      );
}
