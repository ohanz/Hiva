import 'package:hive/hive.dart';

part 'inventory_item.g.dart'; // ← required for adapter

@HiveType(typeId: 0)
class InventoryItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2) // ✅ new field
  String category;

  InventoryItem({
    required this.name,
    required this.description,
    required this.category, // ✅ new parameter
  });
}
