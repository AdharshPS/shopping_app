import 'package:shopping_app/features/cart/domain/repositories/cart_repository.dart';

class DecreaseCount {
  final CartRepository repo;
  DecreaseCount(this.repo);
  Future<void> call(int productId) => repo.decreaseCount(productId);
}
