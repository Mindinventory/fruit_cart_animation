part of 'product_bloc.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class OnDecrementedState extends ProductState {
  final int removedProductListLength;

  OnDecrementedState({required this.removedProductListLength});
}

class CartAddedState extends ProductState {
  final Product product;

  CartAddedState({required this.product});
}

class CartUpdatedState extends ProductState {}
