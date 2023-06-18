import 'package:guardian_project/bootstrap/base_bootstrap.dart';
import 'package:guardian_project/model/model.dart';

/// bootstraper to initialize DB when app is lunched
class DbInitializerBootstrap extends BaseBootStarp {
  /// ctor
  DbInitializerBootstrap.init();

  @override
  Future<void> run() async {
    final success = await DbModel().initializeDB();
    if (!success) throw Exception("DB hasn't succeed in initializing");
  }
}
