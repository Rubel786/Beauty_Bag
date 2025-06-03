import 'package:beauty_bag/chat/viewmodel/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:beauty_bag/configures/routes.dart';
import 'package:beauty_bag/configures/theme.dart';
import 'package:beauty_bag/home/viewmodel/product_card_view_model.dart';
import 'package:beauty_bag/utils/wishlist_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'cart/model/card_model.dart';
import 'login/view/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Failed to load .env file: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductCardViewModel()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Beauty Bag',
        theme: AppTheme.lightTheme(context),
        initialRoute: LoginScreen.routeName,
        routes: routes,
      ),
    );
  }
}


