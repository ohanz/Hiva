import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // ✅ REQUIRED

import 'package:provider/provider.dart';

import 'UI/views/home/home_model.dart';
import 'app/models/inventory_item.dart';
import 'app/provider_list.dart';
import 'app/router.dart'; // ✅ only this, not .gr.dart

final _appRouter = AppRouter(); // ✅ create your app router instance

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register the adapter
  await Hive.initFlutter();
  Hive.registerAdapter(InventoryItemAdapter());

  // Open your inventory box (box name: 'inventory')
  await Hive.openBox<InventoryItem>('inventory');

  final homeModel = HomeModel();
  await homeModel.loadData(); // 👈 Load and seed if empty


  // final box = await Hive.openBox<InventoryItem>('inventory');
  // await box.clear(); // 🚨 Clears everything in 'inventory' box

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
