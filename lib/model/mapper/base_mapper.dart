import 'package:guardian_project/model/model_object/base_model_object.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

/// connect a [TableBase] object to a [ModelObject]
abstract class Mapper<T extends ModelObject, E extends TableBase> {
  /// list of already mapped items (to avoid resolving already resolved model object)
  final Map<int, ModelObject> _alreadyMappedModelObject;
  final Map<int, TableBase> _alreadyMappedTable;
  Map<int, ModelObject> get alreadyMappedModelObject => _alreadyMappedModelObject;
  Map<int, TableBase> get alreadyMappedTable => _alreadyMappedTable;

  /// ctor
  Mapper(this._alreadyMappedModelObject, this._alreadyMappedTable);

  /// [ModelObject] -> [TableBase]
  E toBaseTable(T modelObject);

  /// [TableBase] -> [ModelObject]
  T toModelObject(E table);
}
