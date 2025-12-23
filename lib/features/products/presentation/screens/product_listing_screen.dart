import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/core/enums/product_categories.dart';
import 'package:shopping_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:shopping_app/features/auth/presentation/screens/login_screen.dart';
import 'package:shopping_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:shopping_app/features/products/domain/entities/products_entity.dart';
import 'package:shopping_app/features/products/presentation/provider/products_list_provider.dart';
import 'package:shopping_app/features/products/presentation/screens/product_details_screen.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.wait([
        context.read<ProductsListProvider>().getProducts(),
        context.read<AuthProvider>().getUserDetails(),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  context.read<AuthProvider>().loginedUser?.name ?? '',
                ),
                const SizedBox(height: 20),
                _buildCatergoriesWidget(),
                const SizedBox(height: 20),
                Consumer<ProductsListProvider>(
                  builder: (context, consumer, child) {
                    return _productsList(products: consumer.categoryProducts);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () async {
            Future.wait([
              context.read<AuthProvider>().logout(),
              context.read<CartProvider>().deleteAllCart(),
            ]);
            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          },
          icon: Icon(Icons.logout, color: Colors.green),
        ),
      ],
    );
  }

  Widget _buildCatergoriesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Browse Categories',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Consumer<ProductsListProvider>(
            builder: (context, consumer, child) {
              return Row(
                children: List.generate(consumer.catergoriesList.length, (
                  index,
                ) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _categoryWidget(
                      category: consumer.catergoriesList[index],
                      onTap: () {
                        consumer.changeCategory(index);
                      },
                      isSelected: consumer.selectedCategoryIndex == index,
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _categoryWidget({
    required ProductCategories category,
    Function()? onTap,
    bool isSelected = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          category.productCategoryToString,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _productsList({required List<ProductsEntity> products}) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
        mainAxisExtent: 200,
      ),
      itemBuilder: (context, index) {
        return _productCard(
          product: products[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailsScreen(product: products[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _productCard({required ProductsEntity product, Function()? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 2,
              color: Colors.grey[300]!,
              offset: Offset(3, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Center(
                child: Hero(
                  tag: 'product-${product.id}',
                  child: Image.network(
                    product.image ?? '',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image);
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Text(
                product.title ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Text(
                '\u20B9 ${product.price ?? ''}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
