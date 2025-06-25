import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/extensions/size_extension.dart';
import '../../../app/size_config.dart';
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3, // TODO: replace with model.items.length
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 2.height,
                            horizontal: 4.5.width,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 2.height), // instead of fixed height
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 2.width),
                                width: 16.width,
                                decoration: BoxDecoration(
                                  color: Colors.green[600],
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.home,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 3.height,
                                  horizontal: 3.width,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text(
                                      'Name', // TODO: display model.items[index].name
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Description', // TODO: display model.items[index].description
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              PopupMenuButton<String>(
                                onSelected: (item) {
                                  if (item == 'update') {
                                    nameController.text = 'update name'; // TODO: use real value
                                    descriptionController.text = 'update description'; // TODO: use real value
                                    inputItemDialog(context, 'update', index);
                                  } else if (item == 'delete') {
                                    // TODO: model.deleteItem(index);
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: 'update',
                                    child: Text('Update'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => inputItemDialog(context, 'add'),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 8.width,
            ),
          ),
        );
      },
    );
  }

  void inputItemDialog(BuildContext context, String action, [int? index]) {
    final inventoryDb = Provider.of<HomeModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight * 0.9,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                          (value == null || value.isEmpty) ? 'Item name cannot be empty' : null,
                          decoration: const InputDecoration(labelText: 'Item name'),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: descriptionController,
                          validator: (value) =>
                          (value == null || value.isEmpty) ? 'Item description cannot be empty' : null,
                          decoration: const InputDecoration(labelText: 'Item description'),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (action == 'add') {
                                // TODO: inventoryDb.addItem(nameController.text, descriptionController.text);
                              } else {
                                // TODO: inventoryDb.updateItem(index!, nameController.text, descriptionController.text);
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
              );
            },
          ),
        );
      },
    );
  }
}
