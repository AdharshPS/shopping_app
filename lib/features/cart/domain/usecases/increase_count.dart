import 'package:shopping_app/features/cart/domain/repositories/cart_repository.dart';

class IncreaseCount {
  final CartRepository repo;
  IncreaseCount(this.repo);
  Future<void> call(int productId) => repo.increaseCount(productId);
}
