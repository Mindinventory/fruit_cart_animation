part of 'product_bloc.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class OnIncrementedState extends ProductState {}

class OnDecrementedState extends ProductState {
  final Product product;
  final List<Product> cartItemList;

  OnDecrementedState({required this.product, required this.cartItemList});
}

class OnUpdatedCartState extends ProductState {}
