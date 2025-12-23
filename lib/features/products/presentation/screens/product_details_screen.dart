import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/features/cart/domain/entities/cart_entity.dart';
import 'package:shopping_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:shopping_app/features/dashboard/presentation/screens/bottom_navigation_screen.dart';
import 'package:shopping_app/features/products/domain/entities/products_entity.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final ProductsEntity product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cart = context.read<CartProvider>();
      cart.isAlreadyInCart(widget.product.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _showProductImage(),
                const SizedBox(height: 20),
                _showTitle(widget.product),
                const SizedBox(height: 12),
                _showPriceAndCart(
                  product: widget.product,
                  isLoading: context.watch<CartProvider>().addToCartLoading,
                  alreadyInCarts:
                      context.watch<CartProvider>().isInCart ?? false,
                  addToCart: () async {
                    await context.read<CartProvider>().addToCart(
                      CartEntity(count: 1, product: widget.product),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _showReviewsAndDescription(widget.product),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showProductImage() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 300,
      child: Hero(
        tag: 'product-${widget.product.id}',
        child: Image.network(
          widget.product.image ?? '',
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 100);
          },
        ),
      ),
    );
  }

  Widget _showTitle(ProductsEntity product) {
    return Text(
      product.title ?? '',
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    );
  }

  Widget _showPriceAndCart({
    required ProductsEntity product,
    Function()? addToCart,
    bool isLoading = false,
    bool alreadyInCarts = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '\u20B9 ${product.price ?? ''}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        InkWell(
          onTap: alreadyInCarts
              ? () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationScreen(index: 1),
                  ),
                  (route) => false,
                )
              : addToCart,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Text(
                    alreadyInCarts ? 'Added to Carts' : 'Add to Carts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _showReviewsAndDescription(ProductsEntity product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Rating
        _ratingWidget(
          rate: product.rating?.rate ?? 0,
          count: product.rating?.count ?? 0,
        ),

        const SizedBox(height: 20),

        // ✅ Description
        const Text(
          'Description',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 8),

        Text(
          product.description ?? '',
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _ratingWidget({required double rate, required int count}) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber.shade700),
        const SizedBox(width: 4),
        Text(
          rate.toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),
        Text('($count reviews)', style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
