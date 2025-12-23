import 'package:shopping_app/features/products/data/datasources/product_listing_ds.dart';
import 'package:shopping_app/features/products/domain/entities/products_entity.dart';
import 'package:shopping_app/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductListingDs ds;
  ProductsRepositoryImpl(this.ds);
  @override
  Future<List<ProductsEntity>> getProductList() async {
    final modelList = await ds.getProductList();
    return modelList.map((e) => e.toEntity()).toList();
  }
}
