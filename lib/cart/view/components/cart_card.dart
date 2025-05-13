// lib/widgets/cart_card.dart
import 'package:beauty_bag/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/cart_item_model.dart';

class CartCard extends StatelessWidget {
  final String productName;
  final String productImageUrl;
  final double unitPrice;

  const CartCard({
    super.key,
    required this.productName,
    required this.productImageUrl,
    required this.unitPrice,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartItemModel(unitPrice),
      child: Card(
        color: kPrimaryBodyColor,
        margin: const EdgeInsets.symmetric( vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  productImageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Consumer<CartItemModel>(
                      builder: (context, model, _) => Text(
                        '\$${model.total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Consumer<CartItemModel>(
                builder: (context, model, _) => LayoutBuilder(
                  builder: (context, constraints) {
                    double spacing = constraints.maxWidth > 320 ? 12 : 4;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _compactButton(Icons.remove, model.decrement),
                              Text('${model.quantity}', style: const TextStyle(fontSize: 12)),
                              _compactButton(Icons.add, model.increment),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _compactButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(icon, size: 14, color: Colors.brown),
      ),
    );
  }
}
