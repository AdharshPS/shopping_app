import 'package:shopping_app/features/products/domain/entities/products_entity.dart';

abstract class ProductsRepository {
  Future<List<ProductsEntity>> getProductList();
}
