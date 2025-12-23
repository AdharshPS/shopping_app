import 'package:hive/hive.dart';
import 'package:shopping_app/features/cart/domain/entities/cart_entity.dart';
import 'package:shopping_app/features/products/data/models/products_model.dart';
part 'cart_model.g.dart';

@HiveType(typeId: 0)
class CartModel extends HiveObject {
  @HiveField(0)
  final int count;
  @HiveField(1)
  final ProductsModel product;
  CartModel({required this.count, required this.product});

  CartEntity toEntity() =>
      CartEntity(count: count, product: product.toEntity());

  factory CartModel.fromEntity(CartEntity entity) => CartModel(
    count: entity.count,
    product: ProductsModel.fromEntity(entity.product),
  );

  CartModel copyWith({int? id, int? count, ProductsModel? product}) =>
      CartModel(count: count ?? this.count, product: product ?? this.product);
}
