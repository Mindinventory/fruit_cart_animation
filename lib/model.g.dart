// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      name: json['name'] as String,
      image: json['image'] as String,
      price: json['price'] as String,
      itemInCart: json['itemInCart'] as int?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
      'itemInCart': instance.itemInCart,
    };
