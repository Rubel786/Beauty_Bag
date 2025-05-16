import 'package:beauty_bag/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryBodyColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),

      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 15,
          bottom: 15,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: Colors.brown,
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "9641 Sunset Bivd, Beverly Hills",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.brown,
                          ),
                        ),
                        Text(
                          "California",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: kSecondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios_outlined, color: Colors.brown),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                // Promo Code Input
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 42,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        hintText: 'Enter Promo Code',
                        hintStyle: const TextStyle(
                          fontSize: 12
                        ),
                        labelText: 'Promo Code',
                        labelStyle: TextStyle(color: Colors.brown, fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Apply Button
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Apply promo logic
                      },
                      child: const Text(
                        'APPLY',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Mulish",
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
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
