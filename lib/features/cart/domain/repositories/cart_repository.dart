import 'package:shopping_app/features/cart/domain/entities/cart_entity.dart';

abstract class CartRepository {
  Future<void> addToCart(CartEntity cartEntity);
  Future<List<CartEntity>> getFromCart();
  Future<void> deleteFromCart(int key);
  bool isInCart(String productId);
  Future<void> increaseCount(int productId);
  Future<void> decreaseCount(int productId);
  Future<void> deleteAllCart();
}
