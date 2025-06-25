import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../app/models/inventory_item.dart';

class HomeModel extends ChangeNotifier {
  final Box<InventoryItem> _inventoryBox = Hive.box<InventoryItem>('inventory');

  List<InventoryItem> get items => _inventoryBox.values.toList();

  Future<void> loadData() async {
    // 🔽 Add dummy data if box is empty
    if (_inventoryBox.isEmpty) {
      _inventoryBox.addAll([
        InventoryItem(name: 'Laptop', description: 'HyeBook Pro V1'),
        InventoryItem(name: 'Laptop', description: 'MacBook Pro M1'),
        InventoryItem(name: 'Phone', description: 'Samsung Galaxy S23'),
        InventoryItem(name: 'Desk', description: 'Wooden work desk'),
      ]);
    }

    notifyListeners(); // Important to trigger UI
  }

  void addItem(String name, String description) {
    final newItem = InventoryItem(name: name, description: description);
    _inventoryBox.add(newItem);
    notifyListeners();
  }

  void updateItem(int index, String name, String description) {
    final key = _inventoryBox.keyAt(index);
    final updatedItem = InventoryItem(name: name, description: description);
    _inventoryBox.put(key, updatedItem);
    notifyListeners();
  }

  void deleteItem(int index) {
    final key = _inventoryBox.keyAt(index);
    _inventoryBox.delete(key);
    notifyListeners();
  }
}
