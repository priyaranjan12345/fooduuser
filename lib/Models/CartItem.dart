import 'dart:convert';

import 'Item.dart';

class CartItem {
  final Item item;
  final double subtotal;
  final int quantity;
  CartItem({
    this.item,
    this.subtotal,
    this.quantity,
  });

  CartItem copyWith({
    Item item,
    int subtotal,
    int quantity,
  }) {
    return CartItem(
      item: item ?? this.item,
      subtotal: subtotal ?? this.subtotal,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item.toMap(),
      'subtotal': subtotal,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      item: Item.fromMap(map['item']),
      subtotal: map['subtotal']?.toInt(),
      quantity: map['quantity']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source));

  @override
  String toString() =>
      '  CartItem(item: $item, subtotal: $subtotal, quantity: $quantity)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem &&
        other.item == item &&
        other.subtotal == subtotal &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => item.hashCode ^ subtotal.hashCode ^ quantity.hashCode;
}
