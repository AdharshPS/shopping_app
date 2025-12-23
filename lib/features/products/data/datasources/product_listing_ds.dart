import 'dart:convert';

import 'package:shopping_app/features/products/data/models/products_model.dart';
import 'package:http/http.dart' as http;

class ProductListingDs {
  Future<List<ProductsModel>> getProductList() async {
    String url = 'https://fakestoreapi.com/products';
    final response = await http.get(Uri.parse(url));
    final decodedData = jsonDecode(response.body) as List;
    final productList = decodedData
        .map((json) => ProductsModel.fromJson(json))
        .toList();
    return List.unmodifiable(productList);
  }
}
