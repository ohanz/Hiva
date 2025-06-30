import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../app/models/inventory_item.dart';

enum SortType { az, za }

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


  String _searchQuery = '';
  String get searchQuery => _searchQuery; // ✅ Add this line

  set searchQuery(String value) {
    _searchQuery = value.toLowerCase();
    notifyListeners();
  }

  // List<InventoryItem> get filteredItems {
  //   if (_searchQuery.isEmpty) return items;
  //   return items.where((item) {
  //     return item.name.toLowerCase().contains(_searchQuery) ||
  //         item.description.toLowerCase().contains(_searchQuery);
  //   }).toList();
  // }


  SortType _sortType = SortType.az; // ✅ Add this line
  SortType get sortType => _sortType;


  void setSortType(SortType type) {
  _sortType = type;
  notifyListeners();
  }

  List<InventoryItem> get filteredItems {
    List<InventoryItem> list = items;

    if (_searchQuery.isNotEmpty) {
      list = list.where((item) {
        return item.name.toLowerCase().contains(_searchQuery) ||
            item.description.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Now apply sorting
    list.sort((a, b) {
      if (_sortType == SortType.az) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      } else {
        return b.name.toLowerCase().compareTo(a.name.toLowerCase());
      }
    });

    return list;
  }


}
