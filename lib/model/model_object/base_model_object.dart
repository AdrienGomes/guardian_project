import 'package:uuid/uuid.dart';

/// base class to describe an object from the DB model
abstract class ModelObject {
  /// empty ctor
  ModelObject.empty();

  /// techId_ to identify the entry within the DB (part of the PK)
  int techId_ = const Uuid().v4().hashCode;

  /// the namle of the entry in DB (part of the PK)
  String name = "";
}
