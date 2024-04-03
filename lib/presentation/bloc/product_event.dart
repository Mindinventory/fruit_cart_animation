part of 'product_bloc.dart';

abstract class ProductEvent {}

class OnIncrementEvent extends ProductEvent {
  final Product product;
  final List<Product> cartItemList;

  OnIncrementEvent({required this.product, required this.cartItemList});
}

class OnDecrementEvent extends ProductEvent {
  final Product product;
  final List<Product> cartItemList;

  OnDecrementEvent({required this.product, required this.cartItemList});
}

class OnAddingCartEvent extends ProductEvent{

}