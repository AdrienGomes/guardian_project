import 'package:guardian_project/model/model_object/base_model_object.dart';
import 'package:guardian_project/model/repository/base_repository.dart';
import 'package:guardian_project/model/repository/hot_word_repository.dart';
import 'package:guardian_project/model/repository/listening_session_repository.dart';

/// ## DB client service
///
/// **purpose : Unique entry point to communicate with the database**
class DbClientService {
  late List<Repository> _repositories;

  DbClientService.init() {
    _repositories = [HotWordRepository(this), ListeningSessionRepository(this)];
  }

  /// save an item to DB
  Future<void> saveToDb<T extends ModelObject>(T modelObject, [DBTransaction? runningTransaction]) async {
    final entryFound = await getItemByName<T>(modelObject.name);
    if (entryFound != null) modelObject.techId_ = entryFound.techId_;

    await _repositories
        .firstWhere((rep) => rep.isCompatible(T))
        .saveAsync(modelObject, runningTransaction ?? DBTransaction.start());
  }

  /// save list of items to DB
  Future<void> saveToDbAsList<T extends ModelObject>(List<T> modelObjects, [DBTransaction? runningTransaction]) async {
    for (final mo in modelObjects) {
      final entryFound = await getItemByName<T>(mo.name);
      if (entryFound != null) mo.techId_ = entryFound.techId_;
    }

    if (modelObjects.isNotEmpty) {
      await _repositories
          .firstWhere((rep) => rep.isCompatible(T))
          .saveList(modelObjects, runningTransaction ?? DBTransaction.start());
    }
  }

  /// get an item from DB by it's techId_
  Future<T?> getItemById<T extends ModelObject>(String techId_) async {
    final itemsFound = (await (_repositories.firstWhere((rep) => rep.isCompatible(T)) as Repository<T>)
        .searchAsync("techId_ = '$techId_'"));

    return itemsFound.isNotEmpty ? itemsFound.first : null;
  }

  /// get an item from DB by it's name
  Future<T?> getItemByName<T extends ModelObject>(String name) async {
    final itemsFound =
        (await (_repositories.firstWhere((rep) => rep.isCompatible(T)) as Repository<T>).searchAsync("name = '$name'"));

    return itemsFound.isNotEmpty ? itemsFound.first : null;
  }

  /// search on a specific table
  Future<List<T>> getItems<T extends ModelObject>({List<String> sortAxes = const []}) async =>
      // always sort by name (unique key on every table same as techId_)
      (await (_repositories.firstWhere((rep) => rep.isCompatible(T)) as Repository<T>)
          .searchAsync("", sortAxes: ["name", ...sortAxes]));
}

/// describe a Database transaction
///
/// A DB transaction allow to vreate/update in a row several model object keeping in mind thode already treated
class DBTransaction {
  final Map<int, ModelObject> _modelObjects = {};

  DBTransaction.start();

  /// register a [ModelObject] to the transaction
  void registerModelObject(ModelObject object) => _modelObjects.putIfAbsent(object.techId_, () => object);

  /// retrieve a [ModelObject] from the transaction
  ModelObject? getModelObject(ModelObject object) =>
      _modelObjects.containsKey(object.techId_) ? _modelObjects[object.techId_] : null;
}
