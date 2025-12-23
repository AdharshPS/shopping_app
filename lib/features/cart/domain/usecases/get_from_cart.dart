import 'package:shopping_app/features/cart/domain/entities/cart_entity.dart';
import 'package:shopping_app/features/cart/domain/repositories/cart_repository.dart';

class GetFromCart {
  final CartRepository repo;
  GetFromCart(this.repo);
  Future<List<CartEntity>> call() => repo.getFromCart();
}
