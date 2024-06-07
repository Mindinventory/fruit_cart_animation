import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_cart_animation/common/constants.dart';
import 'package:fruit_cart_animation/model/product.dart';
import 'package:fruit_cart_animation/presentation/bloc/product_bloc.dart';

class CustomProductCard extends StatefulWidget {
  final Product product;
  final int index;
  final int removedProductListLength;
  const CustomProductCard({
    super.key,
    required this.product,
    required this.index,
    required this.removedProductListLength,
  });

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
              border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  right: widget.index % 2 != 0 ? BorderSide.none : BorderSide(color: Colors.grey.withOpacity(0.3))),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    key: product.key,
                    product.image,
                    height: AppConstants.productImageHeight,
                  ),
                ),
                const SizedBox(
                  height: 3,
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
                              product.name,
                              style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "₹ ${product.price}/KG",
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
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
                                onTap: () {
                                  _productBloc.add(OnDecrementEvent(
                                      product: widget.product,
                                      removedProductListLength: widget.removedProductListLength));
                                },
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 16,
                                )),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white),
                              child: Text(
                                product.itemInCart.toString(),
                                style: const TextStyle(color: Colors.black, fontSize: 12),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  _productBloc.add(OnIncrementEvent(product: widget.product));
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
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
