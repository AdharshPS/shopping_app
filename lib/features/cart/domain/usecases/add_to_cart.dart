import 'package:shopping_app/features/cart/domain/entities/cart_entity.dart';
import 'package:shopping_app/features/cart/domain/repositories/cart_repository.dart';

class AddToCart {
  final CartRepository repo;
  AddToCart(this.repo);
  Future<void> call(CartEntity entity) => repo.addToCart(entity);
}
