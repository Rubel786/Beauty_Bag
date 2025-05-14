import 'package:beauty_bag/utils/dotted_line.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryBodyColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),

      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 15,
          bottom: 15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total items (2)",
                  style: const TextStyle(
                    fontFamily: "Muli",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryTextColor,
                  ),
                ),
                Text(
                  "\$51.86",
                  style: const TextStyle(
                    fontFamily: "Muli",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Shipping",
                  style: const TextStyle(
                    fontFamily: "Muli",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryTextColor,
                  ),
                ),
                Text(
                  "\$20.0",
                  style: const TextStyle(
                    fontFamily: "Muli",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 18,),
            DottedLine(),
            SizedBox(height: 13,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Payment",
                  style: const TextStyle(
                    fontFamily: "Muli",
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryTextColor,
                  ),
                ),
                Text(
                  "\$20.0",
                  style: const TextStyle(
                    fontFamily: "Muli",
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
