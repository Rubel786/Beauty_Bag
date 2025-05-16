import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/dotted_line.dart';
import '../../model/card_model.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key});

  final double shippingCharge = 10.0;

  @override
  Widget build(BuildContext context) {

    return Consumer<CartModel>(
      builder: (context, cart, _) {
        if (cart.isUpdating) {
          return Center(
            child: LoadingAnimationWidget.waveDots(
              color: kPrimaryColor,
              size: 50,
            ),
          );
        }

        final totalItems = cart.items.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        );
        final subtotal = cart.totalPrice;
        final totalPayment = subtotal + shippingCharge;

        return Container(
          decoration: BoxDecoration(
            color: kPrimaryBodyColor,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total items ($totalItems)",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kPrimaryTextColor,
                      ),
                    ),
                    Text(
                      "\$${subtotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Shipping",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kPrimaryTextColor,
                      ),
                    ),
                    Text(
                      "\$10.00",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const DottedLine(),
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Payment",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: kPrimaryTextColor,
                      ),
                    ),
                    Text(
                      "\$${totalPayment.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
