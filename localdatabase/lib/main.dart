import 'package:flutter/material.dart';
import 'package:localdatabase/ui/item_screen.dart';
import 'utils/dbhelper.dart';
import 'models/list_items.dart';
import 'models/shopping_list.dart';
import 'ui/shopping_list_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShList(),
    );
  }
}

class ShList extends StatefulWidget {
  const ShList({Key key}) : super(key: key);

  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  List<ShoppingListModel> shoppingList;
  DbHelper helper = DbHelper();

  ShoppingListDialog dialog;

  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: ListView.builder(
        itemCount: (shoppingList != null) ? shoppingList.length : 0,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(shoppingList[index].name),
            onDismissed: (direction) {
              String strName = shoppingList[index].name;
              helper.deleteList(shoppingList[index]);
              setState(() {
                shoppingList.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$strName deleted'),
                ),
              );
            },
            child: ListTile(
              title: Text(shoppingList[index].name),
              leading: CircleAvatar(
                child: Text(
                  shoppingList[index].priority.toString(),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ItemScreen(
                      shoppingList[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => dialog.buildDialog(
              context,
              ShoppingListModel(0, '', 0),
              true,
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  Future showData() async {
    await helper.openDb();
    shoppingList = await helper.getLists();
    setState(
      () {
        shoppingList = shoppingList;
      },
    );
  }
}
