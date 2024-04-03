import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_cart_animation/common/common_methods.dart';
import 'package:fruit_cart_animation/common/constants.dart';
import 'package:fruit_cart_animation/model/product.dart';
import 'package:fruit_cart_animation/presentation/bloc/product_bloc.dart';
import 'package:fruit_cart_animation/presentation/widgets/circular_icon_button.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../widgets/product_card_widget.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  List<Product> productItemList = [
    Product(
        name: "Banana", image: "assets/banana.png", price: "99", itemInCart: 0),
    Product(
        name: "Grapes",
        image: "assets/grapes.png",
        price: '105',
        itemInCart: 0),
    Product(
        name: "Guava", image: 'assets/guava.png', price: '60', itemInCart: 0),
    Product(
        name: "Lemon", image: 'assets/lemon.png', price: '89', itemInCart: 0),
    Product(
        name: "Mango", image: 'assets/mango.png', price: '100', itemInCart: 0),
    Product(
        name: "Orange", image: 'assets/orange.png', price: '60', itemInCart: 0),
    Product(
        name: "Pineapple",
        image: 'assets/pineapple.png',
        price: '80',
        itemInCart: 0),
    Product(
        name: "Strawberry",
        image: 'assets/strawberry.png',
        price: '70',
        itemInCart: 0),
    Product(
        name: "Watermelon",
        image: 'assets/watermelon.png',
        price: '59',
        itemInCart: 0),
  ];

  List<Product> cartItem = [];
  late AnimationController controller;
  late Animation<double> animation;
  late double totalPrice;
  final scrollController = ScrollController();
  double cartLength = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    animation = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.easeInOutCubic))
        .animate(controller);
    totalPrice = 0.0;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30),
              height: 75,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: productItemList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.175, crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return BlocConsumer<ProductBloc, ProductState>(
                    buildWhen: (previous, current) {
                      return
                          current is OnDecrementedState || current is CartAddedState;

                    },
                    listener: (context, state) {
                      if (state is OnDecrementedState) {
                        productItemList[index] = state.product;
                        cartItem = state.cartItemList;
                        totalPrice =
                            totalPrice - double.parse(state.product.price);
                      } else if (state is CartAddedState) {

                        cartItem = state.cartItemList;
                        totalPrice =
                            totalPrice + double.parse(state.product.price);
                        if (cartLength > MediaQuery.of(context).size.width) {
                          Future.delayed(const Duration(milliseconds: 200), () {
                            scrollAfter(scrollController,
                                scrollController.position.maxScrollExtent);
                          });
                          controller.value = 0;
                          cartItem.add(productItemList[index]);

                          Future.delayed(
                            cartLength > MediaQuery.of(context).size.width
                                ? const Duration(milliseconds: 0)
                                : const Duration(seconds: 0),
                            () => showAnimation(
                                context,
                                productItemList[index].key,
                                productItemList[index].image,
                                animation,
                                controller,
                                cartItem,
                                cartLength),
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      return CustomProductCard(
                        product: productItemList[index],
                        cartItem: cartItem,
                        globalKey:productItemList[index].key,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: cartItem.isNotEmpty
            ? MediaQuery.of(context).size.height / 4
            : MediaQuery.of(context).size.height / 8,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4)),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (cartItem.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: cartItem.length,
                    itemBuilder: (BuildContext context, int index) {
                      cartLength = index == 0
                          ? ((2 * AppConstants.cartMarginWidth) +
                              AppConstants.cardWidth)
                          : (((2 * AppConstants.cartMarginWidth) +
                                  AppConstants.cardWidth) +
                              (index *
                                  ((2 * AppConstants.cartMarginWidth) +
                                      AppConstants.cardWidth)) +
                              AppConstants.cardWidth);

                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          double dx = lerpDouble(-86, 0, animation.value)!;

                          return Transform.translate(
                            offset: controller.value != 1 &&
                                    cartItem.length - 1 == index
                                ? Offset(dx, 0)
                                : const Offset(0, 0),
                            child: Snappable(
                              key: GlobalObjectKey(cartItem[index]),
                              duration: const Duration(seconds: 2),
                              onSnapped: () {
                                setState(() {
                                  totalPrice = totalPrice -
                                      double.parse(cartItem[index].price);
                                  cartItem[index].itemInCart =
                                      cartItem[index].itemInCart! - 1;
                                  cartItem.remove(cartItem[index]);
                                });
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: (controller.value != 1 &&
                                            cartItem.length - 1 == index)
                                        ? const Offstage()
                                        : Image.asset(

                                            cartItem[index].image,
                                            height: 50,
                                            width: 50,
                                          ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Opacity(
                                      opacity: cartItem.length - 1 == index
                                          ? controller.value
                                          : 1,
                                      child: CircularIconButton(
                                        onTap: () {
                                          if (cartItem[index].itemInCart == 1) {
                                            (GlobalObjectKey(cartItem[index]).currentState as SnappableState)
                                                .snap()
                                                .then((value) {});
                                          } else if (cartItem[index]
                                                  .itemInCart!>
                                              0) {
                                            setState(() {
                                              totalPrice = totalPrice -
                                                  double.parse(
                                                      cartItem[index].price);
                                              cartItem[index].itemInCart =
                                                  cartItem[index].itemInCart! -
                                                      1;
                                            });
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
                                      opacity: cartItem.length - 1 == index
                                          ? controller.value
                                          : 1,
                                      child: CircularIconButton(
                                        decorationColor: Colors.black87,
                                        onTap: () {},
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            cartItem[index]
                                                .itemInCart
                                                .toString(),
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
                padding: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height / 8,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.4)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 40,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
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
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 40,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.lock,
                            color: Colors.black87,
                            size: 20,
                          ),
                          const Text('Pay'),
                          const Spacer(),
                          Text("₹ $totalPrice"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
