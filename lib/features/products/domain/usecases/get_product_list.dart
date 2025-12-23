import 'package:shopping_app/features/products/domain/entities/products_entity.dart';
import 'package:shopping_app/features/products/domain/repositories/products_repository.dart';

class GetProductList {
  final ProductsRepository repo;
  GetProductList(this.repo);
  Future<List<ProductsEntity>> call() => repo.getProductList();
}
