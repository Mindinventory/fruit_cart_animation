// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      name: json['name'] as String,
      image: json['image'] as String,
      price: json['price'] as String,
      itemInCart: (json['itemInCart'] as num?)?.toInt(),
      backgroundColorCode: (json['backgroundColorCode'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
      'itemInCart': instance.itemInCart,
      'backgroundColorCode': instance.backgroundColorCode,
    };
