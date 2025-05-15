import 'package:flutter/material.dart';
import 'package:beauty_bag/home/view/components/middle_container.dart';
import 'package:beauty_bag/home/view/components/top_container.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../utils/logout_confirmation_dialog.dart';
import '../model/product_card_model.dart';
import '../viewmodel/product_card_view_model.dart';
import 'components/product_card.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final productCardViewModel = Provider.of<ProductCardViewModel>(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (void didPop) async {
        await showLogoutDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Hi Rubel !!!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Mulish",
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          backgroundColor: kPrimaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Provider<ProductCardViewModel>(
          // Wrap HomeScreen with Provider
          create: (context) => ProductCardViewModel(), // Create the ViewModel
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TopContainer(),
                    SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Popular Items",
                            style: TextStyle(
                              color: Colors.brown,
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to full product list screen
                            },
                            child: Text(
                              "View all",
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    // ProductListView(),
                    productCardViewModel.isLoading
                        ? Center(
                      child: LoadingAnimationWidget.threeRotatingDots(
                        color: kPrimaryColor,
                        size: 50,
                      ),
                    )
                        : SizedBox(
                          height: 250, // Adjust height as needed
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productCardViewModel.products.length,
                            itemBuilder: (context, index) {
                                final post = productCardViewModel.products[index];
                                final products = ProductCardModel(
                                  id: post.id,
                                  productName: post.productName,
                                  price: post.price,
                                  rating: post.rating,
                                  images: post.images,
                                  isWhishlist: false,
                                );
                                return ProductCard(product: products);
                              },
                          ),
                        ),
                  ],
                ),
                MiddleContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
