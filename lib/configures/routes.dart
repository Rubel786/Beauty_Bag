import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:beauty_bag/favourite/view/favourite_screen.dart';
import 'package:beauty_bag/login/view/login_screen.dart';
import 'package:beauty_bag/profile/view/profile_screen.dart';
import '../home/view/home_screen.dart';
import '../init_screen.dart';



final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  FavouriteScreen.routeName: (context) => FavouriteScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
};

