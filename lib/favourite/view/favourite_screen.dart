import 'package:flutter/material.dart';
import 'package:beauty_bag/init_screen.dart';
import 'package:beauty_bag/utils/constants.dart';
import 'package:provider/provider.dart';
import '../../home/view/components/product_card.dart';
import '../../utils/wishlist_provider.dart';


class FavouriteScreen extends StatelessWidget {
  static String routeName = "/favourite";

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvoked:(void didPop) async {
        Navigator.pushReplacementNamed(context, InitScreen.routeName);
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text("Favourites"),
          titleTextStyle: TextStyle(fontFamily: 'Mulish', fontSize: 20, color: Colors.brown),
        ),
        body: wishlistProvider.wishlist.isEmpty
            ? const Center(child: Text("No Favorites Yet!"))
            : Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: wishlistProvider.wishlist.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisExtent: 220, // Fixed height per card (adjust as needed)
            ),
            itemBuilder: (context, index) {
              return ProductCard(
                product: wishlistProvider.wishlist[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
