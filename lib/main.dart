import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_cart_animation/presentation/bloc/product_bloc.dart';
import 'package:fruit_cart_animation/presentation/pages/product_page.dart';
import 'package:fruit_cart_animation/presentation/pages/update_product_page.dart';

import 'common/dimension.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Dimens.portraitDesignSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => ProductBloc(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              fontFamily: 'SF Pro Display',
            ),
            themeMode: ThemeMode.light,
            home: const UpdateProductPage(),
          ),
        );
      },
    );
  }
}
