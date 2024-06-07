import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_cart_animation/common/common_methods.dart';
import 'package:fruit_cart_animation/common/constants.dart';
import 'package:fruit_cart_animation/model/product.dart';
import 'package:fruit_cart_animation/presentation/bloc/product_bloc.dart';
import 'package:fruit_cart_animation/presentation/widgets/circular_icon_button.dart';
import 'package:fruit_cart_animation/presentation/widgets/filled_button.dart';
import 'package:fruit_cart_animation/presentation/widgets/outlined_button.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../widgets/product_card_widget.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with TickerProviderStateMixin {
  List<Product> productItemList = [
    Product(name: "Banana", image: "assets/banana.png", price: "99", itemInCart: 0),
    Product(name: "Grapes", image: "assets/grapes.png", price: '105', itemInCart: 0),
    Product(name: "Guava", image: 'assets/guava.png', price: '60', itemInCart: 0),
    Product(name: "Lemon", image: 'assets/lemon.png', price: '89', itemInCart: 0),
    Product(name: "Mango", image: 'assets/mango.png', price: '100', itemInCart: 0),
    Product(name: "Orange", image: 'assets/orange.png', price: '60', itemInCart: 0),
    Product(name: "Pineapple", image: 'assets/pineapple.png', price: '80', itemInCart: 0),
    Product(name: "Strawberry", image: 'assets/strawberry.png', price: '70', itemInCart: 0),
    Product(name: "Watermelon", image: 'assets/watermelon.png', price: '59', itemInCart: 0),
    Product(name: "Kiwi", image: 'assets/kiwi.png', price: '400', itemInCart: 0),
  ];
  Set<Product> removedProductItemList = {};

  late AnimationController controller;
  late Animation<double> animation;
  late AnimationController productRemovedAnimationController;

  final scrollController = ScrollController();
  double cartLength = 0;
  late ProductBloc _productBloc;

  @override
  void initState() {
    super.initState();
    _productBloc = context.read<ProductBloc>();
    controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeInOutCubic)).animate(controller);
    productRemovedAnimationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _productBloc.totalPrice = 0.0;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                height: 50,
                width: double.infinity,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(14)),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: Colors.grey.withOpacity(0.3),
                      )),
                  child: GridView.builder(
                    itemCount: productItemList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 0, childAspectRatio: 1.175, crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return BlocConsumer<ProductBloc, ProductState>(
                        buildWhen: (previous, current) {
                          return current is OnDecrementedState;
                        },
                        listener: (context, state) {
                          if (state is CartAddedState) {
                            if (!_productBloc.cartItemList.contains(state.product)) {
                              if (cartLength > MediaQuery.of(context).size.width) {
                                Future.delayed(const Duration(milliseconds: 200), () {
                                  scrollAfter(scrollController, scrollController.position.maxScrollExtent);
                                });
                              }
                              controller.value = 0;
                              _productBloc.cartItemList.add(state.product);

                              Future.delayed(
                                cartLength > MediaQuery.of(context).size.width
                                    ? const Duration(milliseconds: 0)
                                    : const Duration(seconds: 0),
                                () => showAnimation(context, state.product.key, state.product.image, animation,
                                    controller, _productBloc.cartItemList, cartLength),
                              );
                            }
                          }
                        },
                        builder: (context, state) {
                          return CustomProductCard(
                            removedProductListLength: removedProductItemList.length,
                            index: index,
                            product: productItemList[index],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder(
          bloc: _productBloc,
          builder: (context, state) {
            return Container(
              clipBehavior: Clip.hardEdge,
              height: _productBloc.cartItemList.isNotEmpty
                  ? MediaQuery.of(context).size.height / 4
                  : MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey.withOpacity(0.4)),
              child: Align(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_productBloc.cartItemList.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          scrollDirection: Axis.horizontal,
                          itemCount: _productBloc.cartItemList.length,
                          itemBuilder: (BuildContext context, int index) {
                            cartLength = index == 0
                                ? ((2 * AppConstants.cartMarginWidth) + AppConstants.cardWidth)
                                : (((2 * AppConstants.cartMarginWidth) + AppConstants.cardWidth) +
                                    (index * ((2 * AppConstants.cartMarginWidth) + AppConstants.cardWidth)) +
                                    AppConstants.cardWidth);

                            return removedProductItemList.contains(_productBloc.cartItemList[index])
                                ? TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 1, end: 0),
                                    onEnd: () {
                                      removedProductItemList.remove(_productBloc.cartItemList[index]);
                                      _productBloc
                                          .add(OnCartItemDecrementEvent(cartItem: _productBloc.cartItemList[index]));
                                    },
                                    duration: const Duration(milliseconds: 450),
                                    builder: (context, value, child) {
                                      return SizedBox(
                                        width: 86 * value,
                                      );
                                    },
                                  )
                                : AnimatedBuilder(
                                    animation: animation,
                                    builder: (context, child) {
                                      double dx = lerpDouble(-86, 0, animation.value)!;

                                      return Transform.translate(
                                        offset: controller.value != 1 && _productBloc.cartItemList.length - 1 == index
                                            ? Offset(dx, 0)
                                            : const Offset(0, 0),
                                        child: Snappable(
                                          key: GlobalObjectKey(_productBloc.cartItemList[index]),
                                          duration: const Duration(seconds: 1, milliseconds: 500),
                                          onSnapped: () {
                                            removedProductItemList.add(_productBloc.cartItemList[index]);
                                            setState(() {});
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: 70,
                                                height: 70,
                                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: (controller.value != 1 &&
                                                        _productBloc.cartItemList.length - 1 == index)
                                                    ? const Offstage()
                                                    : Image.asset(
                                                        _productBloc.cartItemList[index].image,
                                                        height: 50,
                                                        width: 50,
                                                      ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                child: Opacity(
                                                  opacity: _productBloc.cartItemList.length - 1 == index
                                                      ? controller.value
                                                      : 1,
                                                  child: CircularIconButton(
                                                    onTap: () {
                                                      if (_productBloc.cartItemList[index].itemInCart == 1) {
                                                        (GlobalObjectKey(_productBloc.cartItemList[index]).currentState
                                                                as SnappableState)
                                                            .snap()
                                                            .then((value) {});
                                                      } else if (_productBloc.cartItemList[index].itemInCart! > 0) {
                                                        _productBloc.add(OnCartItemDecrementEvent(
                                                            cartItem: _productBloc.cartItemList[index]));
                                                      }
                                                    },
                                                    decorationColor: Colors.white,
                                                    child: const Icon(
                                                      Icons.remove_circle,
                                                      size: 16,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 35,
                                                bottom: 0,
                                                child: Opacity(
                                                  opacity: _productBloc.cartItemList.length - 1 == index
                                                      ? controller.value
                                                      : 1,
                                                  child: CircularIconButton(
                                                    decorationColor: Colors.black87,
                                                    onTap: () {},
                                                    child: Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text(
                                                        _productBloc.cartItemList[index].itemInCart.toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                          },
                        ),
                      )
                    else
                      const Offstage(),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 8,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                          color: Colors.white.withOpacity(0.4)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButtonWidget(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 2.4,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.shopping_cart,
                                  color: Colors.black87,
                                  size: 20,
                                ),
                                Text('View Cart'),
                              ],
                            ),
                          ),

                          FilledButtonWidget(
                            fillColor: const Color(0xff70CB8D),
                            height: 50,
                            width: MediaQuery.of(context).size.width / 2.4,
                            enable: true,
                            text: 'Pay : ₹ ${_productBloc.totalPrice}',
                          )
                          // Container(
                          //   padding: const EdgeInsets.all(10),
                          //   height: 40,
                          //   width: MediaQuery.of(context).size.width / 2.4,
                          //   decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                          //   child: const Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //     children: [
                          //       Icon(
                          //         Icons.shopping_cart,
                          //         color: Colors.black87,
                          //         size: 20,
                          //       ),
                          //       Text('View Cart'),
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //   padding: const EdgeInsets.all(10),
                          //   height: 40,
                          //   width: MediaQuery.of(context).size.width / 2.4,
                          //   decoration: BoxDecoration(
                          //     color: Color(0xff70CB8D),
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //     children: [
                          //       const Text('Pay'),
                          //       const Spacer(),
                          //       Text("₹ ${_productBloc.totalPrice}"),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
