import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:fruit_cart_animation/common/constants.dart';
import 'package:fruit_cart_animation/model/product.dart';

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
  if (box == null || !box.attached)
    return; // Check if the widget is still attached

  final size = box.size;
  final Offset offset = box.localToGlobal(Offset.zero);
  final firstContainerOffset = MediaQuery.of(context).size.height -
      (MediaQuery.of(context).size.height / 4);
  OverlayState overlayState = Overlay.of(context, rootOverlay: true);

  animation = Tween<double>(begin: 0, end: 1).animate(controller);

  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          double translateY =
              lerpDouble(offset.dy, firstContainerOffset, animation.value)! +
                  AppConstants.cartPaddingVertical;
          double translateX;
          if (cartLength < MediaQuery.of(context).size.width) {
            translateX = lerpDouble(
                offset.dx,
                (cartItem.length == 1
                    ? (AppConstants.cartPaddingHorizontal +
                        AppConstants.cartMarginWidth +
                        20)
                    : (((cartItem.length - 1) *
                                (AppConstants.cardWidth +
                                    (2 * AppConstants.cartMarginWidth))) +
                            (AppConstants.cartPaddingHorizontal +
                                AppConstants.cartMarginWidth)) +
                        20),
                animation.value)!;
          } else {
            translateX = lerpDouble(
                offset.dx,
                MediaQuery.of(context).size.width - (AppConstants.cardWidth),
                animation.value)!;
          }

          double interpolatedWidth = lerpDouble(
              size.width, AppConstants.cartImageWidth, animation.value)!;
          double interpolatedHeight = lerpDouble(
              size.height, AppConstants.cartImageHeight, animation.value)!;

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
  controller.animateWith(GravitySimulation(9.8, 0, 1, 0));

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

void scrollAfter(ScrollController scrollController, double offset) {
  scrollController.animateTo(offset,
      duration: const Duration(milliseconds: 700), curve: Curves.ease);
}
