// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(hotSentence) =>
      "Hot sentence : ${hotSentence} has been recognized";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "app_bar_title_home_page":
            MessageLookupByLibrary.simpleMessage("Home Page"),
        "app_bar_title_sound_configuration_page":
            MessageLookupByLibrary.simpleMessage("Sound Conf."),
        "background_task_service_already_alive_task_error_label":
            MessageLookupByLibrary.simpleMessage(
                "Task is already alive, can\'t launch another one"),
        "home_page_button_state_off_label":
            MessageLookupByLibrary.simpleMessage("Deactivated"),
        "home_page_button_state_on_label":
            MessageLookupByLibrary.simpleMessage("Activated"),
        "level_indicator_gap_detected_label":
            MessageLookupByLibrary.simpleMessage("Gap detected"),
        "sound_configuration_hot_sentence_recognized_toast_label": m0,
        "sound_controller_page_default_hot_sentence":
            MessageLookupByLibrary.simpleMessage("Hello world")
      };
}
