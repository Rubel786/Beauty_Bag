import 'package:beauty_bag/chat/view/chat_screen.dart';
import 'package:beauty_bag/home/view/components/view_all_screen.dart';
import 'package:beauty_bag/product_detail/view/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:beauty_bag/favourite/view/favourite_screen.dart';
import 'package:beauty_bag/login/view/login_screen.dart';
import 'package:beauty_bag/profile/view/profile_screen.dart';
import '../cart/view/cart_screen.dart';
import '../home/model/product_card_model.dart';
import '../home/view/home_screen.dart';
import '../init_screen.dart';



final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  FavouriteScreen.routeName: (context) => FavouriteScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ViewAllScreen.routeName: (context) => ViewAllScreen(),
  ChatScreen.routeName: (context) => ChatScreen(),
  ProductDetailScreen.routeName: (context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductCardModel;
    return ProductDetailScreen(productId: product.id);
  },

};

