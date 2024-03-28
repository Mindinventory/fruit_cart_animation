import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with TickerProviderStateMixin {
  List<Map<String, String>> data = [
    {"image": "assets/banana.png", "text": "Banana", "price": "99/DZ"},
    {"image": "assets/grapes.png", "text": "Grapes", "price": "105/KG"},
    {"image": "assets/guava.png", "text": "Guava", "price": "60/KG"},
    {"image": "assets/lemon.png", "text": "Lemon", "price": "89/KG"},
    {"image": "assets/mango.png", "text": "Mango", "price": "100/KG"},
    {"image": "assets/orange.png", "text": "Orange", "price": "60/KG"},
    {"image": "assets/pineapple.png", "text": "Pineapple", "price": "80/KG"},
    {"image": "assets/strawberry.png", "text": "Strawberry", "price": "70/KG"},
    {"image": "assets/watermelon.png", "text": "Watermelon", "price": "59/KG"},
  ];
  late AnimationController controller;
  late AnimationController cardAnimationController;

  final double totalPrice = 0;
  int _itemCount = 0;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
    Future.delayed(const Duration(milliseconds: 100), () => controller.forward());

    cardAnimationController = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        cardAnimationController.forward();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 10),
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
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1.1, crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Hero(
                              tag: data[index]['image']!,
                              child: Image.asset(
                                data[index]['image']!,
                                height: 75,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data[index]['text']!,
                                    style:
                                        const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "₹ ${data[index]['price']!}",
                                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          if (_itemCount > 0) {
                                            setState(() {
                                              _itemCount--;
                                            });
                                          }
                                        },
                                        child: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 16,
                                        )),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                                      decoration:
                                          BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white),
                                      child: Text(
                                        _itemCount.toString(),
                                        style: const TextStyle(color: Colors.black, fontSize: 12),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            _itemCount++;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 16,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height / 4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4)),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
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
        ),
      ),
    );
  }
}
