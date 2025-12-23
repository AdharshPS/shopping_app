import 'package:shopping_app/features/cart/domain/repositories/cart_repository.dart';

class IsInCart {
  final CartRepository repo;
  IsInCart(this.repo);
  bool call(String productId) => repo.isInCart(productId);
}
