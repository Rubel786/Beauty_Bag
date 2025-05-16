// lib/widgets/cart_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants.dart';
import '../../model/card_model.dart';
import '../../model/cart_item_model.dart';

class CartCard extends StatelessWidget {
  final CartItemModel item;

  const CartCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: item,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: kPrimaryBodyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.productImageUrl,
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
                      Text(
                        item.productName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Consumer<CartItemModel>(
                        builder:
                            (_, model, __) => Text(
                              '\$${model.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Consumer<CartItemModel>(
                  builder:
                      (context, model, _) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              size: 16,
                              model.quantity == 1 ? Icons.delete : Icons.remove,
                            ),
                            onPressed: () {
                              Provider.of<CartModel>(context, listen: false).decrementItem(item);
                            },
                          ),
                          Text('${model.quantity}'),
                          IconButton(
                            icon: const Icon(Icons.add,size: 16,),
                            onPressed: () {
                              Provider.of<CartModel>(context, listen: false).incrementItem(item);
                            },                          ),
                        ],
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
