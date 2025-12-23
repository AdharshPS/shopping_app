import 'package:shopping_app/features/products/domain/entities/products_entity.dart';

class CartEntity {
  final int count;
  final ProductsEntity product;
  CartEntity({required this.count, required this.product});
}
