import 'package:flutter/material.dart';
import 'package:guardian_project/common/widget/theme/guardian_theme_color.dart';
import 'package:guardian_project/common/widget/theme/theme.dart';
import 'package:guardian_project/model/model_object/listening_session_model_object.dart';

/// build a listening profile's [ListTile]
class ListeningProfileWidget extends StatefulWidget {
  /// true if this is the active listening session
  final bool isActive;

  /// the listening session
  final ListeningSessionModelObject listeningSession;

  /// callback when a listening session gets activated
  final void Function() onActiveListeningSession;

  /// ctor
  const ListeningProfileWidget(
      {super.key, required this.listeningSession, required this.onActiveListeningSession, this.isActive = false});

  @override
  State<StatefulWidget> createState() => _StateListeningSessionWidget();
}

class _StateListeningSessionWidget extends State<ListeningProfileWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ListeningProfileThemeExtension>();

    return Card(
      margin: EdgeInsets.zero,
      elevation: widget.isActive ? 20 : 5,
      color: widget.isActive ? theme?.selectedTileColor : theme?.unselectedTileColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        dense: widget.isActive ? false : true,
        selectedColor: theme?.selectedTextColor,
        tileColor: Colors.transparent,
        textColor: theme?.unselectedTextColor,
        style: ListTileStyle.list,
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
                Icons.check_circle_outline,
                color: GuardianThemeColor.stateOnColor,
              )
            : null,
        onTap: widget.onActiveListeningSession,
        selected: widget.isActive,
      ),
    );
  }
}
