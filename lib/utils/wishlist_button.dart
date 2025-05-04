import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../utils/wishlist_provider.dart';
import '../home/model/product_card_model.dart';

class WishlistButton extends StatelessWidget {
  final ProductCardModel product;

  const WishlistButton({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool isWishlist = wishlistProvider.isInWishlist(product);

    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        wishlistProvider.toggleWishlist(product);
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          color: isWishlist ? Colors.red.withOpacity(0.15) : Colors.grey.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          "assets/icons/heart_icon.svg",
          colorFilter: ColorFilter.mode(
            isWishlist ? Colors.red : Colors.grey,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
