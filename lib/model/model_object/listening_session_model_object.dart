import 'package:guardian_project/model/model_object/base_model_object.dart';
import 'package:guardian_project/model/model_object/hot_word_model_object.dart';

/// Hold information about a listening session
class ListeningSessionModelObject extends ModelObject {
  /// default listening duration constant (in seconds)
  static const _kListeningDuration = Duration(seconds: 5);

  /// the label of the listening session
  String? label = "";

  /// listening session duration
  Duration? duration = _kListeningDuration;

  /// if the listening session is the one active
  bool? isActive = false;

  /// list of hot words used in this listening session as relation
  List<HotWordModelObject>? hotWords = [];

  /// empty ctor
  ListeningSessionModelObject.empty() : super.empty();
}
