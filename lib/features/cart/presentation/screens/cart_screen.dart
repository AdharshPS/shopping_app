import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/features/cart/domain/entities/cart_entity.dart';
import 'package:shopping_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:shopping_app/features/products/domain/entities/products_entity.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<CartProvider>(
          builder: (context, consumer, child) {
            if (consumer.cartItems.isEmpty) {
              return Center(child: Text('No items in cart...'));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: consumer.cartItems.length,
                    itemBuilder: (context, index) =>
                        _buildProductCard(cartItem: consumer.cartItems[index]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total Amount: \u20B9 ${consumer.totalAmount}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _buildButton(
                  buy: () async {
                    _buildDialog();
                    Future.delayed(Duration(milliseconds: 1500), () async {
                      if (!context.mounted) return;
                      await context.read<CartProvider>().deleteAllCart();
                    });
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductCard({required CartEntity cartItem}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400]!,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(3, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(12),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(12),
          child: Row(
            children: [
              _buildImage(cartItem.product.image ?? ''),
              SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildCategoryRow(
                      clearProduct: () async {
                        await context.read<CartProvider>().deleteFromCart(
                          int.tryParse(cartItem.product.id!)!,
                        );
                      },
                      product: cartItem.product,
                    ),
                    _buildProductNameAndCart(
                      decrementCounter: () async {
                        await context.read<CartProvider>().decreaseCount(
                          int.tryParse(cartItem.product.id!)!,
                        );
                      },
                      incrementCounter: () async {
                        await context.read<CartProvider>().increaseCount(
                          int.tryParse(cartItem.product.id!)!,
                        );
                      },
                      cart: cartItem,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String image) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(12),
          child: Image.network(image, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildCategoryRow({
    void Function()? clearProduct,
    required ProductsEntity product,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            product.category ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          onPressed: clearProduct,
          icon: Icon(Icons.delete, color: Colors.red[400]),
        ),
      ],
    );
  }

  Widget _buildProductNameAndCart({
    required void Function() decrementCounter,
    required void Function()? incrementCounter,
    required CartEntity cart,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                cart.product.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '\u20B9 ${cart.product.price ?? 0.0}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 10),

        Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: decrementCounter,
                icon: Icon(
                  Icons.remove,
                  color: cart.count == 1 ? Colors.grey[400] : Colors.white,
                ),
              ),
              Text(
                '${cart.count}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: incrementCounter,
                icon: Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton({Function()? buy}) {
    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: buy,
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            'Buy',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _buildDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (!dialogContext.mounted) return;
          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
          }
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 56),
              SizedBox(height: 16),
              Text(
                'Order Successful!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Items ordered successfully',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        );
      },
    );
  }
}
