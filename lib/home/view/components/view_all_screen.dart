import 'package:beauty_bag/home/view/components/product_card.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../init_screen.dart';
import '../../../utils/constants.dart';
import '../../model/product_card_model.dart';
import '../../viewmodel/product_card_view_model.dart';

class ViewAllScreen extends StatefulWidget {
  static String routeName = "/view_all";

  @override
  _ViewAllScreenState createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductCardModel> _filteredProducts = [];

  @override
  void initState() {
    super.initState();

    final productCardViewModel = Provider.of<ProductCardViewModel>(
      context,
      listen: false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productCardViewModel.fetchProducts().then((_) {
        setState(() {
          _filteredProducts = productCardViewModel.products;
        });
      });
    });
  }

  List<ProductCardModel> _applySearchFilter(String query) {
    final productCardViewModel = Provider.of<ProductCardViewModel>(
      context,
      listen: false,
    );

    if (query.isEmpty) return productCardViewModel.products;

    return productCardViewModel.products
        .where(
          (product) =>
          product.productName.toLowerCase().contains(query.toLowerCase()),
    )
        .toList();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredProducts = _applySearchFilter(query);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productCardViewModel = Provider.of<ProductCardViewModel>(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (void didPop) async {
        Navigator.pushReplacementNamed(context, InitScreen.routeName);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("All Products"),
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.brown,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
          child: Column(
            children: [
              TextFormField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Enter Product Name..',
                  hintStyle: const TextStyle(
                      fontSize: 12,
                  ),
                  labelText: 'Product',
                  labelStyle: TextStyle( fontSize: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                child:
                  productCardViewModel.isLoading
                      ? Center(
                    child: LoadingAnimationWidget.threeRotatingDots(
                      color: kPrimaryColor,
                      size: 50,
                    ),
                  )
                      : SizedBox(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisExtent:
                        220, // Fixed height per card (adjust as needed)
                      ),
                      scrollDirection: Axis.vertical,
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final post = _filteredProducts[index];
                        return ProductCard(product: post);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
