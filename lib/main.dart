import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/provider_list.dart';
import 'app/router.dart'; // ✅ only this, not .gr.dart

final _appRouter = AppRouter(); // ✅ create your app router instance

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Hive Inventory',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Lato',
        ),
        routerDelegate: _appRouter.delegate(), // ✅ required for auto_route
        routeInformationParser: _appRouter.defaultRouteParser(), // ✅ also required
      ),
    );
  }
}
