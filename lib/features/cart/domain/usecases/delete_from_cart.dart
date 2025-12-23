import 'package:shopping_app/features/cart/domain/repositories/cart_repository.dart';

class DeleteFromCart {
  final CartRepository repo;
  DeleteFromCart(this.repo);
  Future<void> call(int key) => repo.deleteFromCart(key);
}
