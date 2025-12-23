import 'package:hive/hive.dart';
import 'package:shopping_app/features/cart/data/models/cart_model.dart';

class CartDs {
  final Box<CartModel> cartBox;
  CartDs(this.cartBox);

  bool isInCart(String productId) {
    return cartBox.values.any((item) => item.product.id == productId);
  }

  Future<void> addToCart(CartModel model) async {
    final exists = isInCart(model.product.id!);
    if (exists) return;
    final key = model.product.id;
    await cartBox.put(key, model);
  }

  Future<List<CartModel>> getFromCart() async {
    return List.unmodifiable(cartBox.values.toList().reversed.toList());
  }

  Future<void> deleteFromCart(int key) async {
    await cartBox.delete(key);
  }

  Future<void> increment(int productId) async {
    for (final key in cartBox.keys) {
      final item = cartBox.get(key);
      if (int.parse(item!.product.id!) == productId) {
        await cartBox.put(key, item.copyWith(count: item.count + 1));
        return;
      }
    }
  }

  Future<void> decrement(int productId) async {
    for (final key in cartBox.keys) {
      final item = cartBox.get(key);

      if (int.parse(item!.product.id!) == productId) {
        if (item.count >= 2) {
          await cartBox.put(key, item.copyWith(count: item.count - 1));
        }
        return;
      }
    }
  }

  Future<void> deleteAllCart() async {
    await cartBox.clear();
  }
}
