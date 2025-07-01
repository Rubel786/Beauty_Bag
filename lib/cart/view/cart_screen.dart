// lib/cart/view/cart_screen.dart
import 'package:beauty_bag/cart/view/checkout_screen.dart';
import 'package:beauty_bag/cart/view/components/address_card.dart';
import 'package:beauty_bag/cart/view/components/payment_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../init_screen.dart';
import '../../transactions/ui/transaction_list_screen.dart'; // Keep this import if you navigate directly to it
import '../../utils/constants.dart';
import '../model/card_model.dart'; // Assuming CartModel is in this file
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
    final cartProvider = Provider.of<CartModel>(context);
    // Ensure totalPrice is accessible from your CartModel
    final double totalPrice = cartProvider.totalPrice; // Assuming CartModel has a totalPrice getter

    return PopScope(
      canPop: false,
      onPopInvoked: (void didPop) async {
        Navigator.pushReplacementNamed(context, InitScreen.routeName);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Cart"),
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        body: cartProvider.items.isEmpty
            ? const Center(child: Text("No products added yet!!"))
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Products',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown,
                    ),
                  ),
                ),
                Consumer<CartModel>(
                  builder: (context, cart, _) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cart.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CartCard(item: cart.items[index]);
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Delivery Address',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                AddressCard(),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Payment',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                PaymentCard(),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // Pass the total amount to CheckoutScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                amount: totalPrice, // Pass the dynamic total price
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'PAYMENT',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
