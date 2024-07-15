import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_cart_animation/model/product.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  List<Product> cartItemList = [];
  double totalPrice = 0.0;

  ProductBloc() : super(ProductInitial()) {
    // on<OnIncrementEvent>(increment);
    on<OnDecrementEvent>(_decrement);
    on<OnIncrementEvent>(_increment);
    on<OnCartItemDecrementEvent>(_cartDecrement);
  }

  void _increment(OnIncrementEvent event, Emitter<ProductState> emit) async {
    try {
      event.product.itemInCart = (event.product.itemInCart! + 1);
      totalPrice = totalPrice + double.parse(event.product.price);
      emit(CartAddedState(
        product: event.product,
      ));
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  void _cartDecrement(OnCartItemDecrementEvent event, Emitter<ProductState> emit) async {
    try {
      debugPrint('totalPrice $totalPrice');
      if (event.cartItem.itemInCart != null) {
        totalPrice = totalPrice - (double.parse(event.cartItem.price) * event.cartItem.itemInCart!.toDouble());
      }
      // event.cartItem.itemInCart = event.cartItem.itemInCart! - 1;
      event.cartItem.itemInCart = 0;
      if (event.cartItem.itemInCart == 0) {
        cartItemList.remove(event.cartItem);
      }
      emit(CartUpdatedState());
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  void _decrement(OnDecrementEvent event, Emitter<ProductState> emit) async {
    try {
      if (event.product.itemInCart! > 0 && event.product.itemInCart! != 0) {
        event.product.itemInCart = (event.product.itemInCart! - 1);
        totalPrice = totalPrice - double.parse(event.product.price);
        if (cartItemList.contains(event.product) && event.product.itemInCart! < 1) {
          cartItemList.remove(event.product);
        }
      }

      emit(OnDecrementedState(removedProductListLength: event.removedProductListLength));
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }
}
