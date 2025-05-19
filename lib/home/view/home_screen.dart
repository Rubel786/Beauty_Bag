import 'package:flutter/material.dart';
import 'package:beauty_bag/home/view/components/middle_container.dart';
import 'package:beauty_bag/home/view/components/top_container.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../utils/logout_confirmation_dialog.dart';
import '../model/product_card_model.dart';
import '../service/product_card_service.dart';
import '../viewmodel/product_card_view_model.dart';
import 'components/product_card.dart';
import 'components/view_all_screen.dart';

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
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          backgroundColor: kPrimaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Provider<ProductCardViewModel>(
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
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                ViewAllScreen.routeName,
                              );
                            },
                            child: Text(
                              "View all",
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
