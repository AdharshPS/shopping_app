import 'package:shopping_app/features/cart/data/datasources/cart_ds.dart';
import 'package:shopping_app/features/cart/data/models/cart_model.dart';
import 'package:shopping_app/features/cart/domain/entities/cart_entity.dart';
import 'package:shopping_app/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartDs local;
  CartRepositoryImpl(this.local);

  List<CartModel> cartList = [];

  @override
  Future<void> addToCart(CartEntity cartEntity) async {
    final model = CartModel.fromEntity(cartEntity);
    await local.addToCart(model);
  }

  @override
  Future<List<CartEntity>> getFromCart() async {
    cartList = await local.getFromCart();
    return cartList.map((element) => element.toEntity()).toList();
  }

  @override
  Future<void> deleteFromCart(int key) async {
    await local.deleteFromCart(key);
  }

  @override
  bool isInCart(String productId) {
    return local.isInCart(productId);
  }

  @override
  Future<void> decreaseCount(int productId) async {
    await local.decrement(productId);
  }

  @override
  Future<void> increaseCount(int productId) async {
    await local.increment(productId);
  }

  @override
  Future<void> deleteAllCart() async {
    await local.deleteAllCart();
  }
}
