import 'package:flutter_modular/flutter_modular.dart';

import 'home_scaffold.dart';

class AppModule extends Module {
  // Provide a list of dependencies to inject into your project

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (_) => const HomeScaffold());
  }
}
