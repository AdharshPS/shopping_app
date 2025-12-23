import 'package:flutter/foundation.dart';
import 'package:shopping_app/core/enums/product_categories.dart';
import 'package:shopping_app/features/products/domain/entities/products_entity.dart';
import 'package:shopping_app/features/products/domain/repositories/products_repository.dart';
import 'package:shopping_app/features/products/domain/usecases/get_product_list.dart';

class ProductsListProvider with ChangeNotifier {
  final ProductsRepository repo;
  final GetProductList _getProductList;
  ProductsListProvider(this.repo) : _getProductList = GetProductList(repo);

  List<ProductCategories> catergoriesList = [
    ProductCategories.all,
    ProductCategories.electronics,
    ProductCategories.jewelery,
    ProductCategories.mensClothing,
    ProductCategories.womensClothing,
  ];

  int selectedCategoryIndex = 0;
  ProductCategories selectedCategory = ProductCategories.all;

  List<ProductsEntity> _products = [];
  List<ProductsEntity> categoryProducts = [];

  void changeCategory(int index) {
    if (selectedCategoryIndex == index) return;
    selectedCategoryIndex = index;
    selectedCategory = catergoriesList[selectedCategoryIndex];
    getCategoryList();
    notifyListeners();
  }

  Future<void> getProducts() async {
    _products = await _getProductList();
    _products.sort(
      (a, b) => (a.title)!.toLowerCase().compareTo(b.title!.toLowerCase()),
    );
    getCategoryList();
    notifyListeners();
  }

  void getCategoryList() {
    categoryProducts = selectedCategory == ProductCategories.all
        ? _products
        : _products.where((element) {
            return fromApi(element.category) == selectedCategory;
          }).toList();
  }
}
