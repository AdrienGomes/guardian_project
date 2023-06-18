import 'package:guardian_project/model/model_object/base_model_object.dart';
import 'package:guardian_project/service/db_client_service.dart';

/// A repository is the last object communicating with a table from the DB
abstract class Repository<T extends ModelObject> {
  /// db client service
  final DbClientService dbClientService;

  Repository(this.dbClientService);

  /// returns true if a type can be used by this repository
  bool isCompatible(Type type) => type == T;

  /// save or create an entry within the DB
  Future<void> saveAsync(T modelObject, DBTransaction transaction);

  /// save or create entries within the DB
  Future<void> saveList(List<T> modelObjects, DBTransaction transaction);

  /// retrieves a list of data from the DB
  Future<List<T>> searchAsync(String whereClause,
      {List<String> sortAxes = const [], int pageSize = 10, int pageNumber = 0});
}
