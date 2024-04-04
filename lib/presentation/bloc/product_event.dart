part of 'product_bloc.dart';

abstract class ProductEvent {}

class OnIncrementEvent extends ProductEvent {
  final Product product;

  OnIncrementEvent({required this.product});
}

class OnDecrementEvent extends ProductEvent {
  final Product product;
  OnDecrementEvent({required this.product});
}

class OnCartItemDecrementEvent extends ProductEvent {
  final Product cartItem;

  OnCartItemDecrementEvent({required this.cartItem});
}
