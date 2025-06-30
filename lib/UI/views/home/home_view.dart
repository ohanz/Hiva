import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/extensions/size_extension.dart';
import '../../../app/size_config.dart';
import '../../../app/models/inventory_item.dart';
import 'home_model.dart';

@RoutePage()
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {}); // Refresh to show/hide clear icon  | Just rebuild to update suffixIcon
    });
  }
  //And don’t forget to dispose it:
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Consumer<HomeModel>(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 6.height),
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Hive Inventory',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Lato',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding( // Search Area
                      padding: EdgeInsets.symmetric(horizontal: 4.width, vertical: 2.height),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search items...',
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              Provider.of<HomeModel>(context, listen: false).searchQuery = '';
                            },
                          )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          Provider.of<HomeModel>(context, listen: false).searchQuery = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align( // Sort Area
                      alignment: Alignment.centerRight,
                      child: PopupMenuButton<SortType>(
                        onSelected: (value) {
                          Provider.of<HomeModel>(context, listen: false).setSortType(value);
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: SortType.az,
                            child: Text('Sort A–Z'),
                          ),
                          PopupMenuItem(
                            value: SortType.za,
                            child: Text('Sort Z–A'),
                          ),
                        ],
                        icon: Icon(Icons.sort),
                      ),
                    ),
                    const SizedBox(height: 20),
                    model.items.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        'No items yet. Tap + to add one!',
                        style: TextStyle(
                          color: Colors.black,
                          // color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    )
                        : model.filteredItems.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'No items found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: model.filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = model.filteredItems[index];
                        // itemCount: model.items.length,
                      // itemBuilder: (context, index) {
                      //   final item = model.items[index];

                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 2.height,
                            horizontal: 4.5.width,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 2.height),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 2.width),
                                width: 16.width,
                                height: 16.width,
                                decoration: BoxDecoration(
                                  color: Colors.green[600],
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.inventory,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.width),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.description,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (itemAction) {
                                  if (itemAction == 'update') {
                                    nameController.text = item.name;
                                    descriptionController.text = item.description;
                                    inputItemDialog(context, 'update', index);
                                  } else if (itemAction == 'delete') {
                                    model.deleteItem(index);
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(value: 'update', child: Text('Update')),
                                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Created with ❤️ by Ohanz',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),

                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => inputItemDialog(context, 'add'),
            child: Icon(Icons.add, color: Colors.green, size: 8.width),
            // child: Icon(Icons.add, color: Colors.white, size: 8.width),
          ),
        );
      },
    );
  }

  void inputItemDialog(BuildContext context, String action, [int? index]) {
    final model = Provider.of<HomeModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      action == 'add' ? 'Add Item' : 'Update Item',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nameController,
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Item name cannot be empty' : null,
                      decoration: const InputDecoration(labelText: 'Item name'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: descriptionController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Item description cannot be empty'
                          : null,
                      decoration: const InputDecoration(labelText: 'Item description'),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (action == 'add') {
                            model.addItem(
                              nameController.text,
                              descriptionController.text,
                            );
                          } else {
                            model.updateItem(
                              index!,
                              nameController.text,
                              descriptionController.text,
                            );
                          }

                          nameController.clear();
                          descriptionController.clear();
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                      ),
                      child: Text(
                        action == 'add' ? 'Add' : 'Update',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
