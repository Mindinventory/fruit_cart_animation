import 'dart:ui';

import 'package:add_to_cart_animation/model.dart';
import 'package:flutter/material.dart';

class CustomProductCard extends StatefulWidget {
  final String image;
  final String name;
  final String price;
  final VoidCallback onIncrementPress;
  final VoidCallback onDecrementPress;
  final int itemCart;
  final GlobalKey globalKey;

  final List<Product> cartItem;

  const CustomProductCard(
      {super.key,
      required this.image,
      required this.name,
      required this.price,
      required this.onIncrementPress,
      required this.onDecrementPress,
      required this.itemCart,
      required this.cartItem,
      required this.globalKey});

  @override
  State<CustomProductCard> createState() => _CustomProductCardState();
}

class _CustomProductCardState extends State<CustomProductCard> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  double previousPosition = 0;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    animation = Tween(begin: 0, end: 1).animate(controller);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
              child: Image.asset(
                key: widget.globalKey,
                widget.image,
                height: 75,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          overflow: TextOverflow.ellipsis,
                          widget.name,
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "₹ ${widget.price}/KG",
                          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 30,
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: widget.onDecrementPress,
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 16,
                            )),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white),
                          child: Text(
                            widget.itemCart.toString(),
                            style: const TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ),
                        InkWell(
                            onTap: widget.onIncrementPress,
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void showAnimation(
  BuildContext context,
  GlobalKey key,
  String image,
  Animation<double> animation,
  AnimationController controller,
  List<Product> cartItem,
  double cartLength,
) {
  final box = key.currentContext?.findRenderObject() as RenderBox?;
  if (box == null || !box.attached) return; // Check if the widget is still attached

  final size = box.size;
  final Offset offset = box.localToGlobal(Offset.zero);
  final firstContainerOffset = MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height / 4);
  OverlayState overlayState = Overlay.of(context, rootOverlay: true);

  animation = Tween<double>(begin: 0, end: 1).animate(controller);

  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          double translateY = lerpDouble(offset.dy, firstContainerOffset, animation.value)! + 20;
          double translateX;
          if (cartLength < MediaQuery.of(context).size.width) {
            translateX = lerpDouble(offset.dx,
                (cartItem.length == 1 ? 18 : (((cartItem.length - 1) * (70 + 16)) + (18))), animation.value)!;
          } else {
            translateX = lerpDouble(offset.dx, MediaQuery.of(context).size.width - (50 + 20), animation.value)!;
          }

          double interpolatedWidth = lerpDouble(size.width, 50, animation.value)!;
          double interpolatedHeight = lerpDouble(size.height, 50, animation.value)!;

          return Positioned(
            top: translateY,
            left: translateX,
            child: Image.asset(
              image,
              width: interpolatedWidth,
              height: interpolatedHeight,
            ),
          );
        },
      );
    },
  );

  overlayState.insert(overlayEntry);
  controller.forward(from: 0);

  animation.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (overlayEntry.mounted) {
          overlayEntry.remove();
        }
      });
    }
  });
}
