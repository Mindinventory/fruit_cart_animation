import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snappable_thanos/snappable_thanos.dart';
import '../../common/common_methods.dart';
import '../../common/constants.dart';
import '../../common/dimension.dart';
import '../../model/product.dart';
import '../bloc/product_bloc.dart';
import '../widgets/circular_icon_button.dart';
import '../widgets/product_card_widget.dart';

class UpdateProductPage extends StatefulWidget {
  const UpdateProductPage({super.key});

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> with TickerProviderStateMixin {
  List<Product> productItemList = [
    Product(name: "Banana", image: "assets/banana.png", price: "99", itemInCart: 0, backgroundColorCode: 0xffFFF3BD),
    Product(name: "Grapes", image: "assets/grapes.png", price: '105', itemInCart: 0, backgroundColorCode: 0xffC0CBEC),
    Product(name: "Guava", image: 'assets/guava.png', price: '60', itemInCart: 0, backgroundColorCode: 0xffc3db90),
    Product(name: "Lemon", image: 'assets/lemon.png', price: '89', itemInCart: 0, backgroundColorCode: 0xffe8d581),
    Product(name: "Mango", image: 'assets/mango.png', price: '100', itemInCart: 0, backgroundColorCode: 0xffFFF4D4),
    Product(name: "Orange", image: 'assets/orange.png', price: '60', itemInCart: 0, backgroundColorCode: 0xffFFE2B6),
    Product(
        name: "Pineapple", image: 'assets/pineapple.png', price: '80', itemInCart: 0, backgroundColorCode: 0xffd8ad8a),
    Product(
        name: "Strawberry",
        image: 'assets/strawberry.png',
        price: '70',
        itemInCart: 0,
        backgroundColorCode: 0xffFFDDDE),
    Product(
        name: "Watermelon",
        image: 'assets/watermelon.png',
        price: '59',
        itemInCart: 0,
        backgroundColorCode: 0xffE7F7D5),
    Product(name: "Kiwi", image: 'assets/kiwi.png', price: '400', itemInCart: 0, backgroundColorCode: 0xffe2c178),
  ];

  ValueNotifier<bool> isCartEmpty = ValueNotifier(true);

  Set<Product> removedProductItemList = {};

  final ScrollController sliverScrollController = ScrollController();

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
    controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: sliverScrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                snap: true,
                primary: true,
                expandedHeight: MediaQuery.of(context).viewPadding.top + 78,
                backgroundColor: const Color(0xfffff6ed),
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: const Color(0xfffff6ed),
                    child: Stack(
                      children: [
                        Positioned(
                          top: MediaQuery.of(context).padding.top + Dimens.h12,
                          left: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deliver To',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: Dimens.font14,
                                  color: const Color(0xff888888),
                                ),
                              ),
                              SizedBox(height: Dimens.h2),
                              Row(
                                children: [
                                  Text(
                                    'Andheri, Mumbai',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: Dimens.font16,
                                      color: const Color(0xff000000),
                                    ),
                                  ),
                                  SizedBox(width: Dimens.w4),
                                  Image.asset(
                                    'assets/icons/arrow_right.png',
                                    fit: BoxFit.scaleDown,
                                    width: Dimens.w16,
                                    height: Dimens.h16,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).padding.top + Dimens.h12,
                          right: 0,
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: Dimens.h44,
                                    width: Dimens.w44,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage('assets/girl.png'),
                                      ),
                                      borderRadius: BorderRadius.circular(Dimens.r12),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      width: Dimens.w12,
                                      height: Dimens.h12,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF79D36),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: Dimens.w2,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: Dimens.w8, right: Dimens.w16),
                                height: Dimens.h44,
                                width: Dimens.w44,
                                decoration: BoxDecoration(
                                  color: const Color(0xff222222),
                                  borderRadius: BorderRadius.circular(Dimens.r12),
                                ),
                                padding: EdgeInsets.all(Dimens.h12),
                                child: Image.asset(
                                  'assets/icons/bell.png',
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: const AppBarBottomSearchWidget(),
              ),
              BlocConsumer<ProductBloc, ProductState>(
                buildWhen: (previous, current) {
                  return ((current is OnDecrementedState) || (current is CartAddedState));
                },
                listener: (context, state) {
                  if (state is CartAddedState) {
                    if (!_productBloc.cartItemList.contains(state.product)) {
                      isCartEmpty.value = false;
                      if (cartLength > MediaQuery.of(context).size.width) {
                        Future.delayed(
                          const Duration(milliseconds: 200),
                          () {
                            scrollAfter(scrollController, scrollController.position.maxScrollExtent);
                          },
                        );
                      }
                      controller.value = 0;
                      _productBloc.cartItemList.add(state.product);

                      Future.delayed(
                        cartLength > MediaQuery.of(context).size.width
                            ? const Duration(milliseconds: 0)
                            : const Duration(seconds: 0),
                        () => showAnimation(context, state.product.key, state.product.image, animation, controller,
                            _productBloc.cartItemList, cartLength),
                      );
                    }
                  } else if (state is CartUpdatedState) {
                    if (_productBloc.cartItemList.isEmpty) {
                      isCartEmpty.value = true;
                    }
                  } else if (state is OnDecrementedState) {
                    if (_productBloc.cartItemList.isEmpty) {
                      isCartEmpty.value = true;
                    }
                  }
                },
                builder: (context, state) {
                  return ValueListenableBuilder(
                    valueListenable: isCartEmpty,
                    builder: (context, value, child) {
                      return SliverPadding(
                        padding: EdgeInsets.only(
                          left: Dimens.w16,
                          right: Dimens.w16,
                          bottom: MediaQuery.of(context).padding.bottom +
                              ((isCartEmpty.value) ? Dimens.w16 : MediaQuery.of(context).size.height / 4),
                          top: Dimens.h16,
                        ),
                        sliver: SliverGrid.builder(
                          itemCount: productItemList.length,
                          itemBuilder: (context, index) {
                            return CustomProductCard(
                              color: Color(productItemList[index].backgroundColorCode ?? 0xffFFFFFF),
                              removedProductListLength: removedProductItemList.length,
                              index: index,
                              product: productItemList[index],
                            );
                          },
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: Dimens.w175 / Dimens.h256,
                            crossAxisSpacing: Dimens.h14,
                            mainAxisSpacing: Dimens.w14,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          Positioned(
            bottom: Dimens.h14,
            right: Dimens.w16,
            left: Dimens.w16,
            child: BlocBuilder(
              bloc: _productBloc,
              builder: (context, state) {
                return AnimatedContainer(
                  height: isCartEmpty.value ? 0 : MediaQuery.of(context).size.height / 4.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.r12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(4, 4),
                        spreadRadius: 3,
                        blurRadius: 16,
                      ),
                    ],
                    color: Colors.transparent,
                  ),
                  duration: const Duration(milliseconds: 500),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // if (_productBloc.cartItemList.isNotEmpty)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: isCartEmpty.value ? 0 : Dimens.h108,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: Dimens.w10, vertical: Dimens.h6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimens.r12),
                            color: Colors.white,
                          ),
                          child: ListView.builder(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
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
                                          width: Dimens.w76 * value,
                                        );
                                      },
                                    )
                                  : AnimatedBuilder(
                                      animation: animation,
                                      builder: (context, child) {
                                        double dx = lerpDouble(-86, 0, animation.value)!;

                                        return Center(
                                          child: Transform.translate(
                                            offset:
                                                controller.value != 1 && _productBloc.cartItemList.length - 1 == index
                                                    ? Offset(dx, 2)
                                                    : const Offset(0, 0),
                                            child: Snappable(
                                              key: GlobalObjectKey(_productBloc.cartItemList[index]),
                                              duration: const Duration(seconds: 1, milliseconds: 200),
                                              onSnapped: () {
                                                removedProductItemList.add(_productBloc.cartItemList[index]);
                                                setState(() {});
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: Dimens.w76,
                                                    height: Dimens.h76,
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal: Dimens.w8, vertical: Dimens.h10),
                                                    padding: EdgeInsets.all(Dimens.h10),
                                                    decoration: BoxDecoration(
                                                      color: Color(
                                                          (_productBloc.cartItemList[index].backgroundColorCode) ??
                                                              0xffCCCCCC),
                                                      borderRadius: BorderRadius.circular(Dimens.r16),
                                                    ),
                                                    child: (controller.value != 1 &&
                                                            _productBloc.cartItemList.length - 1 == index)
                                                        ? const Offstage()
                                                        : Image.asset(
                                                            _productBloc.cartItemList[index].image,
                                                            height: Dimens.h50,
                                                            width: Dimens.w50,
                                                          ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Opacity(
                                                      opacity: _productBloc.cartItemList.length - 1 == index
                                                          ? controller.value
                                                          : 1,
                                                      child: CircularIconButton(
                                                        width: Dimens.w25,
                                                        height: Dimens.h25,
                                                        padding: EdgeInsets.all(Dimens.h6),
                                                        onTap: () {
                                                          if (_productBloc.cartItemList[index].itemInCart != 0) {
                                                            (GlobalObjectKey(_productBloc.cartItemList[index])
                                                                    .currentState as SnappableState)
                                                                .snap();
                                                          } else if (_productBloc.cartItemList[index].itemInCart! > 0) {
                                                            _productBloc.add(
                                                              OnCartItemDecrementEvent(
                                                                  cartItem: _productBloc.cartItemList[index]),
                                                            );
                                                          }
                                                        },
                                                        decorationColor: Colors.red,
                                                        child: Image.asset(
                                                          'assets/trash.png',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: Dimens.w34,
                                                    bottom: 0,
                                                    child: Opacity(
                                                      opacity: _productBloc.cartItemList.length - 1 == index
                                                          ? controller.value
                                                          : 1,
                                                      child: CircularIconButton(
                                                        width: Dimens.w26,
                                                        height: Dimens.h26,
                                                        decorationColor: Colors.white,
                                                        border: Border.all(
                                                            color: const Color(0xffE8E8E8), width: Dimens.w2),
                                                        onTap: () {},
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            _productBloc.cartItemList[index].itemInCart.toString(),
                                                            style: const TextStyle(
                                                              color: Colors.black,
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
                                          ),
                                        );
                                      },
                                    );
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: Dimens.h8),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color(0xff222222),
                            borderRadius: BorderRadius.circular(Dimens.r18),
                          ),
                          padding: EdgeInsets.symmetric(vertical: Dimens.h14, horizontal: Dimens.w16),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '₹ ${_productBloc.totalPrice}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimens.font28,
                                    ),
                                  ),
                                  SizedBox(height: Dimens.h6),
                                  Text(
                                    'Price Includes all other costs',
                                    style: TextStyle(
                                      color: const Color(0xff888888),
                                      fontWeight: FontWeight.w500,
                                      fontSize: Dimens.font14,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(width: Dimens.w17),
                              Container(
                                padding: EdgeInsets.all(Dimens.h16),
                                decoration: BoxDecoration(
                                  color: const Color(0xff444444),
                                  borderRadius: BorderRadius.circular(Dimens.r12),
                                ),
                                child: Center(
                                  child: Text(
                                    'View Cart',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: Dimens.font16,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: Dimens.w8),
                              Container(
                                padding: EdgeInsets.all(Dimens.h16),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF27646),
                                  borderRadius: BorderRadius.circular(Dimens.r12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Pay',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: Dimens.font16,
                                    ),
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }
}

class AppBarBottomSearchWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBottomSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.w16, vertical: Dimens.h16),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              style: TextStyle(
                fontSize: Dimens.font16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                prefixIcon: Container(
                  padding: EdgeInsets.only(
                    left: Dimens.w18,
                    right: Dimens.w8,
                    bottom: Dimens.h16,
                    top: Dimens.h16,
                  ),
                  child: Image.asset(
                    'assets/search.png',
                    fit: BoxFit.scaleDown,
                    height: Dimens.h20,
                    width: Dimens.w20,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search items...',
                hintStyle: TextStyle(
                  fontSize: Dimens.font14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff888888),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xffF2F2F2),
                  ),
                  borderRadius: BorderRadius.circular(Dimens.r26),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xffF2F2F2),
                  ),
                  borderRadius: BorderRadius.circular(Dimens.r26),
                ),
              ),
            ),
          ),
          SizedBox(width: Dimens.w10),
          Container(
            height: Dimens.h52,
            width: Dimens.w52,
            padding: EdgeInsets.all(Dimens.h16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff222222),
            ),
            child: Image.asset('assets/filter.png'),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(Dimens.h98);
}
