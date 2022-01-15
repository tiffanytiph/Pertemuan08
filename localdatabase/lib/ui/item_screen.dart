import 'package:flutter/material.dart';
import 'package:localdatabase/models/list_items.dart';
import 'package:localdatabase/models/shopping_list.dart';
import 'package:localdatabase/utils/dbhelper.dart';

class ItemScreen extends StatefulWidget {
  final ShoppingListModel shoppingList;
  ItemScreen(this.shoppingList);

  @override
  _ItemScreenState createState() => _ItemScreenState(shoppingList);
}

class _ItemScreenState extends State<ItemScreen> {
  ShoppingListModel shoppingList;
  _ItemScreenState(this.shoppingList);
  DbHelper helper;
  List<ListItems> items;

  @override
  Widget build(BuildContext context) {
    helper = DbHelper();
    // showData(this.shoppingList.id);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.shoppingList.name),
        ),
        body: ListView.builder(
          itemCount: (items != null) ? items.length : 0,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                shoppingList.name,
                style: TextStyle(fontSize: 20.0),
              ),
            );
          },
        ));
  }

  Future showData(int idList) async {
    await helper.openDb();
    items = await helper.getItems(idList);
    setState(() {
      items = items;
    });
  }
}
