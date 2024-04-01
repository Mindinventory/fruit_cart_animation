import 'dart:math';
import 'dart:ui';
import 'package:add_to_cart_animation/custom_product_card.dart';
import 'package:add_to_cart_animation/model.dart';

import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

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
  ];

  List<Product> cartItem = [];

  late AnimationController controller;
  late Animation<double> animation;

  final double totalPrice = 0;
  final scrollController = ScrollController();
  double cartLength = 0;

  void scrollAfter(ScrollController scrollController, {required int milliseconds, Offset}) {
    Future.delayed(Duration(milliseconds: milliseconds), () {
      var offset = Offset;
      var scrollDuration = const Duration(milliseconds: 600);
      scrollController.animateTo(offset, duration: scrollDuration, curve: Curves.ease);
    });
  }

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller);

    super.initState();
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    prefixIcon: const Icon(Icons.search),
                  ),
                )),
            Expanded(
              child: GridView.builder(
                itemCount: productItemList.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1.175, crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return CustomProductCard(
                    globalKey: productItemList[index].key,
                    cartItem: cartItem,
                    image: productItemList[index].image,
                    name: productItemList[index].name,
                    itemCart: productItemList[index].itemInCart!,
                    onDecrementPress: () {
                      if (productItemList[index].itemInCart! > 0 && productItemList[index].itemInCart! != 0) {
                        setState(() {
                          productItemList[index].itemInCart = (productItemList[index].itemInCart! - 1);
                          if (cartItem.contains(productItemList[index]) && productItemList[index].itemInCart! < 1) {
                            cartItem.remove(productItemList[index]);
                          }
                        });
                      }
                    },
                    onIncrementPress: () {
                      setState(() {
                        productItemList[index].itemInCart = (productItemList[index].itemInCart! + 1);
                        if (!cartItem.contains(productItemList[index])) {
                          if (cartLength > MediaQuery.of(context).size.width) {
                            scrollAfter(scrollController, milliseconds: 500, Offset: MediaQuery.of(context).size.width);
                            controller.value = 0;
                          }
                          cartItem.add(productItemList[index]);
                          Future.delayed(
                              cartLength > MediaQuery.of(context).size.width
                                  ? const Duration(seconds: 1)
                                  : const Duration(seconds: 0),
                              () => showAnimation(context, productItemList[index].key, productItemList[index].image,
                                  animation, controller, cartItem, cartLength));
                        }
                      });
                    },
                    price: productItemList[index].price,
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: cartItem.isNotEmpty ? MediaQuery.of(context).size.height / 4 : MediaQuery.of(context).size.height / 8,
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
                      cartLength = index == 0 ? 86 : (86 + (index * 78));

                      return AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            // double dx = lerpDouble((((index - 2) * 8) + ((index - 3) * 70)),
                            //     (((index - 1) * 8) + ((index - 2) * 70)), animation.value)!;

                            return Stack(
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
                                  child: (controller.value != 1 && cartItem.length - 1 == index)
                                      ? const Offstage()
                                      : Image.asset(
                                          key: GlobalObjectKey('${cartItem[index].name.hashCode}_cart'),
                                          cartItem[index].image,
                                          height: 50,
                                          width: 50,
                                        ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: InkWell(
                                    onTap: () {
                                      if (cartItem[index].itemInCart! == 1) {
                                        setState(() {
                                          cartItem[index].itemInCart = cartItem[index].itemInCart! - 1;
                                          cartItem.remove(cartItem[index]);
                                        });
                                      } else if (cartItem[index].itemInCart! > 0) {
                                        setState(() {
                                          cartItem[index].itemInCart = cartItem[index].itemInCart! - 1;
                                        });
                                      }
                                    },
                                    child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                            boxShadow: kElevationToShadow[2],
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: const Icon(
                                          Icons.delete,
                                          size: 16,
                                          color: Colors.red,
                                        )),
                                  ),
                                ),
                                Positioned(
                                  right: 35,
                                  bottom: 0,
                                  child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          boxShadow: kElevationToShadow[2],
                                          color: Colors.black87,
                                          shape: BoxShape.circle),
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            cartItem[index].itemInCart.toString(),
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ))),
                                ),
                              ],
                            );
                          });
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
                        decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
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
                        )),
                    Container(
                        padding: const EdgeInsets.all(10),
                        height: 40,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                            color: Colors.green, border: Border.all(), borderRadius: BorderRadius.circular(10)),
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
                            Text("₹ ${totalPrice.toString()}"),
                          ],
                        ))
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
