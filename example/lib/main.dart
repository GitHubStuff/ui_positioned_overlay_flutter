import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'screens/app_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ModularApp(
      module: AppModule(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      title: 'Flutter Demo',

      ///locale: Language.locale,
      theme: null,
      darkTheme: null,
      themeMode: null,
      localizationsDelegates: const [],
    );
  }
}
