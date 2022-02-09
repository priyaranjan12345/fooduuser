import 'dart:convert';

class Item {
  final String itemid;
  final String name;
  final double price;
  final String description;
  final String type;
  final String catid;
  final String restid;
  final String restname;
  Item(
      {this.itemid,
      this.name,
      this.price,
      this.description,
      this.type,
      this.catid,
      this.restid,
      this.restname});

  Item copyWith(
      {String itemid,
      String name,
      double price,
      String description,
      String type,
      String catid,
      String restid,
      String resname}) {
    return Item(
      itemid: itemid ?? this.itemid,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      type: type ?? this.type,
      catid: catid ?? this.catid,
      restid: restid ?? this.restid,
      restname: restname ?? this.restname,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemid': itemid,
      'name': name,
      'price': price,
      'description': description,
      'type': type,
      'catid': catid,
      'restid': restid,
      'restname': restname,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
        itemid: map['itemid'],
        name: map['name'],
        price: map['price']?.toInt(),
        description: map['description'],
        type: map['type'],
        catid: map['catid'],
        restid: map['restid'],
        restname: map['restname']);
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Item(itemid: $itemid, name: $name, price: $price, description: $description, type: $type, catid: $catid, restid: $restid,restname:$restname';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item &&
        other.itemid == itemid &&
        other.name == name &&
        other.price == price &&
        other.description == description &&
        other.type == type &&
        other.catid == catid &&
        other.restid == restid &&
        other.restname == restname;
  }

  @override
  int get hashCode {
    return itemid.hashCode ^
        name.hashCode ^
        price.hashCode ^
        description.hashCode ^
        type.hashCode ^
        catid.hashCode ^
        restid.hashCode ^
        restname.hashCode;
  }
}
