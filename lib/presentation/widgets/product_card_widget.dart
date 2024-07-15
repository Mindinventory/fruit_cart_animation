import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_cart_animation/common/constants.dart';
import 'package:fruit_cart_animation/common/dimension.dart';
import 'package:fruit_cart_animation/model/product.dart';
import 'package:fruit_cart_animation/presentation/bloc/product_bloc.dart';

import 'circular_icon_button.dart';

class CustomProductCard extends StatefulWidget {
  final Product product;
  final int index;
  final int removedProductListLength;
  final Color? color;

  const CustomProductCard(
      {super.key, required this.product, required this.index, required this.removedProductListLength, this.color});

  @override
  State<CustomProductCard> createState() => _CustomProductCardState();
}

class _CustomProductCardState extends State<CustomProductCard> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  late Product product;
  late ProductBloc _productBloc;

  @override
  void initState() {
    _productBloc = context.read<ProductBloc>();
    controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    animation = Tween(begin: 0, end: 1).animate(controller);
    product = widget.product;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {},
      builder: (context, state) {
        return InkWell(
          child: Container(
            padding: AppConstants.kProductContainerPadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.r24),
              border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  right: widget.index % 2 != 0 ? BorderSide.none : BorderSide(color: Colors.grey.withOpacity(0.3))),
              color: widget.color,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        key: product.key,
                        product.image,
                        height: Dimens.h118,
                        width: Dimens.w120,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CircularIconButton(
                        height: Dimens.h36,
                        width: Dimens.w36,
                        padding: EdgeInsets.all(Dimens.h10),
                        decorationColor: Colors.white,
                        onTap: () {},
                        child: Image.asset(
                          'assets/heart.png',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dimens.h20,
                ),
                Text(
                  overflow: TextOverflow.ellipsis,
                  product.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimens.font18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: Dimens.h12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "₹ ${product.price}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: Dimens.font20,
                          ),
                        ),
                        SizedBox(height: Dimens.h2),
                        Text(
                          "per kg",
                          style: TextStyle(
                            color: const Color(0xff888888),
                            fontWeight: FontWeight.w400,
                            fontSize: Dimens.font14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: Dimens.h42,
                      margin: EdgeInsets.only(left: Dimens.w6),
                      padding: EdgeInsets.all(Dimens.h6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(Dimens.r32),
                          left: Radius.circular(Dimens.r32),
                        ),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _productBloc.add(OnDecrementEvent(
                                  product: widget.product, removedProductListLength: widget.removedProductListLength));
                            },
                            child: Container(
                              height: Dimens.h30,
                              width: Dimens.w30,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xffCCCCCC),
                                    width: Dimens.w1,
                                  ),
                                  shape: BoxShape.circle),
                              child: const Center(
                                child: Icon(
                                  Icons.remove,
                                  color: Color(0xffCCCCCC),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimens.w10),
                            child: Text(
                              product.itemInCart.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Dimens.font16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _productBloc.add(OnIncrementEvent(product: widget.product));
                            },
                            child: Container(
                              height: Dimens.h30,
                              width: Dimens.w30,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Color(0xffCCCCCC),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    // Container(
                    //   width: 50,
                    //   height: 30,
                    //   padding: const EdgeInsets.all(1),
                    //   decoration: BoxDecoration(
                    //     color: Colors.green,
                    //     borderRadius: BorderRadius.circular(5),
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       InkWell(
                    //           onTap: () {
                    //             _productBloc.add(OnDecrementEvent(
                    //                 product: widget.product,
                    //                 removedProductListLength: widget.removedProductListLength));
                    //           },
                    //           child: const Icon(
                    //             Icons.remove,
                    //             color: Colors.white,
                    //             size: 16,
                    //           )),
                    //       Container(
                    //         padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                    //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white),
                    //         child: Text(
                    //           product.itemInCart.toString(),
                    //           style: const TextStyle(color: Colors.black, fontSize: 8),
                    //         ),
                    //       ),
                    //       InkWell(
                    //           onTap: () {
                    //             _productBloc.add(OnIncrementEvent(product: widget.product));
                    //           },
                    //           child: const Icon(
                    //             Icons.add,
                    //             color: Colors.white,
                    //             size: 16,
                    //           )),
                    //     ],
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
