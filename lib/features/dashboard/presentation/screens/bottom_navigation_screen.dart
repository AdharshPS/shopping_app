import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:shopping_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:shopping_app/features/dashboard/presentation/provider/nav_provider.dart';
import 'package:shopping_app/features/products/presentation/screens/product_listing_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key, this.index});
  final int? index;

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.index != null) {
        context.read<NavProvider>().changeIndex(widget.index!, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavProvider>();
    final pages = [const ProductListingScreen(), const CartScreen()];
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: nav.index, children: pages),
      bottomNavigationBar: _buildNavBar(nav: nav, context: context),
    );
  }

  Widget _buildNavBar({
    required NavProvider nav,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(18),
        child: BottomNavigationBar(
          currentIndex: nav.index,
          onTap: (value) => nav.changeIndex(value, context),
          backgroundColor: Colors.grey[300],
          fixedColor: Colors.green,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: "Products",
            ),
            BottomNavigationBarItem(
              icon: context.read<CartProvider>().cartItems.isEmpty
                  ? Icon(Icons.shopping_cart)
                  : Badge.count(
                      count: context.watch<CartProvider>().cartItems.length,
                      child: Icon(Icons.shopping_cart),
                    ),
              label: "Cart",
            ),
          ],
        ),
      ),
    );
  }
}
