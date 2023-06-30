import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:guardian_project/common/widget/theme/guardian_theme_color.dart';
import 'package:guardian_project/intl.dart';

/// Creates a list of items where sliding on the right and sliding on the left allow to do special actions
class SlidingAnimatedList extends StatefulWidget {
  /// allow to build child according to item index within the list
  final Widget Function(int index) childBuilder;

  /// the initial number of items to be drawn
  final int initialCount;

  /// callback called when an item is deleted
  final void Function(int)? onDeleteItem;

  /// callback when an item is edited
  final void Function(int)? onEditItem;

  const SlidingAnimatedList(
      {super.key, required this.childBuilder, required this.initialCount, this.onDeleteItem, this.onEditItem});

  @override
  State<SlidingAnimatedList> createState() => _SlidingAnimatedListState();
}

class _SlidingAnimatedListState extends State<SlidingAnimatedList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) => AnimatedList(
      key: _listKey,
      initialItemCount: widget.initialCount,
      itemBuilder: (context, index, animation) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Slidable(
            startActionPane: ActionPane(
              extentRatio: 0.35,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => widget.onEditItem?.call(index),
                  backgroundColor: GuardianThemeColor.commonBlue,
                  icon: Icons.settings,
                  borderRadius: BorderRadius.circular(10),
                  label: tr.common_edit_label,
                )
              ],
            ),
            endActionPane: // The start action pane is the one at the left or the top side.
                ActionPane(
              extentRatio: 0.35,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => deleteItem(index),
                  backgroundColor: GuardianThemeColor.commonRed,
                  icon: Icons.delete,
                  borderRadius: BorderRadius.circular(10),
                  label: tr.common_delete_label,
                )
              ],
            ),
            child: _buildItem(index, animation),
          )));

  /// build a single item
  Widget _buildItem(int index, Animation<double> animation) => SizeTransition(
        sizeFactor: animation,
        child: widget.childBuilder(index),
      );

  /// delete an item from the list
  void deleteItem(int index) {
    // call the onDelete callback
    widget.onDeleteItem?.call(index);

    builder(context, animation) {
      // A method to build the Card widget.
      return _buildItem(index, animation);
    }

    _listKey.currentState?.removeItem(index, builder);
  }
}
