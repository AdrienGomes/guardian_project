// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home Page`
  String get app_bar_title_home_page {
    return Intl.message(
      'Home Page',
      name: 'app_bar_title_home_page',
      desc: '',
      args: [],
    );
  }

  /// `Sound Conf.`
  String get app_bar_title_sound_configuration_page {
    return Intl.message(
      'Sound Conf.',
      name: 'app_bar_title_sound_configuration_page',
      desc: '',
      args: [],
    );
  }

  /// `Activated`
  String get home_page_button_state_on_label {
    return Intl.message(
      'Activated',
      name: 'home_page_button_state_on_label',
      desc: '',
      args: [],
    );
  }

  /// `Deactivated`
  String get home_page_button_state_off_label {
    return Intl.message(
      'Deactivated',
      name: 'home_page_button_state_off_label',
      desc: '',
      args: [],
    );
  }

  /// `Hello world`
  String get sound_controller_page_default_hot_sentence {
    return Intl.message(
      'Hello world',
      name: 'sound_controller_page_default_hot_sentence',
      desc: '',
      args: [],
    );
  }

  /// `Hot sentence : {hotSentence} has been recognized`
  String sound_configuration_hot_sentence_recognized_toast_label(
      String hotSentence) {
    return Intl.message(
      'Hot sentence : $hotSentence has been recognized',
      name: 'sound_configuration_hot_sentence_recognized_toast_label',
      desc: '',
      args: [hotSentence],
    );
  }

  /// `Gap detected`
  String get level_indicator_gap_detected_label {
    return Intl.message(
      'Gap detected',
      name: 'level_indicator_gap_detected_label',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
