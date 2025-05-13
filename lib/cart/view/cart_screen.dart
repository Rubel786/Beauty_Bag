import 'package:beauty_bag/cart/view/components/address_card.dart';
import 'package:flutter/material.dart';

import '../../init_screen.dart';
import 'components/cart_card.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (void didPop) async {
        Navigator.pushReplacementNamed(context, InitScreen.routeName);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true, // fixes height issue
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return CartCard(
                      productName: "Jeans",
                      productImageUrl: "assets/images/default_avatar.jpg",
                      unitPrice: 35.0,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Delivery Address', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.brown)),
                ),
                SizedBox(height: 5,),
                AddressCard(),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Payment', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.brown)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
