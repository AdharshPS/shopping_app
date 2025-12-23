import 'package:shopping_app/features/cart/domain/repositories/cart_repository.dart';

class DeleteAllCart {
  final CartRepository repo;
  DeleteAllCart(this.repo);
  Future<void> call() => repo.deleteAllCart();
}
