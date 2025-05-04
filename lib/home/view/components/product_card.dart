import 'package:flutter/material.dart';
import 'package:beauty_bag/home/model/product_card_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/wishlist_button.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,

    //  required this.onPress,
  }) : super(key: key);
  final ProductCardModel product;

  // final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 150,
        height:250,
        child: GestureDetector(
          // onTap: onPress,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border(),
                  color: kPrimaryBodyColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WishlistButton(product: product),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.orangeAccent,
                              size: 16,
                            ),
                            Text(
                              "${product.rating}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Image.network(
                      product.images[0],
                      // Prefer first image, else thumbnail
                      width: 100,
                      height: 100,
                      // errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.productName,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  /* WishlistButton(product: product),*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
