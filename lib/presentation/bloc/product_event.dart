part of 'product_bloc.dart';

abstract class ProductEvent {}

class OnIncrementEvent extends ProductEvent {}

class OnDecrementEvent extends ProductEvent {
  final Product product;
  final List<Product> cartItemList;

  OnDecrementEvent({required this.product, required this.cartItemList});
}

class OnUpdatingCartEvent extends ProductEvent {}
