class ListItems {
  int id;
  int idList;
  String name;
  String quantity;
  String note;

  ListItems(
    this.id,
    this.idList,
    this.name,
    this.quantity,
    this.note,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      'idList': idList,
      'name': name,
      'quantitiy': quantity,
      'note': note,
    };
  }
}
