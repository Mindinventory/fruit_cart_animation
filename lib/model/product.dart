import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product {
  String name;
  String image;
  String price;
  int? itemInCart;
  @JsonKey(includeFromJson: false, includeToJson: false)
  GlobalKey key = GlobalKey();

  Product(
      {required this.name,
      required this.image,
      required this.price,
      required this.itemInCart});
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
