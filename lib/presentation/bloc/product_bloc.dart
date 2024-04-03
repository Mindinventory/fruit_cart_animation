import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_cart_animation/model/product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    // on<OnIncrementEvent>(increment);
    on<OnDecrementEvent>(_decrement);
    // on<OnUpdatingCartEvent>(UpdateCart);
    // on<AddMessageEvent>(_addMessage);
    // on<UpdateMessageEvent>(_updateMessage);

    // void _increment(OnIncrementEvent event, Emitter<ProductState> emit) async {
    //   try {
    //
    //
    //
    //
    //     emit(OnIncrementedState());
    //   } catch (error) {
    //     print( error.toString());
    //   }
    // }
  }
  void _decrement(OnDecrementEvent event, Emitter<ProductState> emit) async {
    try {
      if (event.product.itemInCart! > 0 && event.product.itemInCart! != 0) {
        event.product.itemInCart = (event.product.itemInCart! - 1);

        if (event.cartItemList.contains(event.product) && event.product.itemInCart! < 1) {
          event.cartItemList.remove(event.product);
        }
      }

      emit(OnDecrementedState(
        product: event.product,
        cartItemList: event.cartItemList,
      ));
    } catch (error) {
      print(error.toString());
    }
  }
}
