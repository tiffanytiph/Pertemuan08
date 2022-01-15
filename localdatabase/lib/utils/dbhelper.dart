import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/list_items.dart';
import '../models/shopping_list.dart';

class DbHelper {
  final int version = 1;
  Database db;

  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper() {
    return _dbHelper;
  }

  // Open Db
  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(
        join(await getDatabasesPath(), 'shopping.db'),
        onCreate: (database, version) {
          database.execute(
              'CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');
          database.execute(
              'CREATE TABLE items(id INTEGER PRIMARY KEYS, idList INTEGER, name TEXT, quantity TEXT, note TEXT, ' +
                  'FOREIGN KEY(idList) REFERENCES lists(id))');
        },
        version: version,
      );
    }

    return db;
  }

  // Test Db
  Future testDb() async {
    final db = await openDb();

    // db dummy
    await db.execute('INSERT INTO lists VALUES(0, "FRUITS", 2)');
    await db.execute(
        'INSERT INTO items VALUES(0, 0, "APPLES", "2 kg", "better if they are red.")');
    List lists = await db.rawQuery('SELECT * from lists');
    List items = await db.rawQuery('SELECT * from items');
    print(lists[0].toString());
    print(items[0].toString());
  }

  // insert data shopping list
  Future<int> insertList(ShoppingListModel list) async {
    int id = await this.db.insert(
          'lists',
          list.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  // insert data list items
  Future<int> insertItems(ListItems item) async {
    int id = await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  // get list
  Future<List<ShoppingListModel>> getLists() async {
    final List<Map<String, dynamic>> maps = await db.query('lists');
    return List.generate(maps.length, (i) {
      return ShoppingListModel(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['priority'],
      );
    });
  }

  // get items
  Future<List<ListItems>> getItems(int idList) async {
    final List<Map<String, dynamic>> maps =
        await db.query('items', where: 'idList = ?', whereArgs: [idList]);
    return List.generate(maps.length, (i) {
      return ListItems(
        maps[i]['id'],
        maps[i]['idList'],
        maps[i]['name'],
        maps[i]['quantity'],
        maps[i]['note'],
      );
    });
  }

  // function delete
  Future<int> deleteList(ShoppingListModel list) async {
    int result =
        await db.delete("items", where: "idList = ?", whereArgs: [list.id]);
    result = await db.delete("list", where: "id = ?", whereArgs: [list.id]);
    return result;
  }
}
