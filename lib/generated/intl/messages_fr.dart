// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fr';

  static String m0(hotSentence) =>
      "Phrase clée : ${hotSentence} a été reconnue";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "app_bar_title_home_page":
            MessageLookupByLibrary.simpleMessage("Acceuil"),
        "app_bar_title_sound_configuration_page":
            MessageLookupByLibrary.simpleMessage("Conf. Son"),
        "background_task_service_already_alive_task_error_label":
            MessageLookupByLibrary.simpleMessage(
                "Une tâche est déjà active, impossible d\'en lancer une seconde"),
        "home_page_button_state_off_label":
            MessageLookupByLibrary.simpleMessage("Désactivé"),
        "home_page_button_state_on_label":
            MessageLookupByLibrary.simpleMessage("Activé"),
        "level_indicator_gap_detected_label":
            MessageLookupByLibrary.simpleMessage("Différence détectée"),
        "sound_configuration_hot_sentence_recognized_toast_label": m0,
        "sound_controller_page_default_hot_sentence":
            MessageLookupByLibrary.simpleMessage("Bonjour")
      };
}
