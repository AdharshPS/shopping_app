import 'package:flutter/foundation.dart';
import 'package:shopping_app/features/cart/domain/entities/cart_entity.dart';
import 'package:shopping_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:shopping_app/features/cart/domain/usecases/add_to_cart.dart';
import 'package:shopping_app/features/cart/domain/usecases/decrease_count.dart';
import 'package:shopping_app/features/cart/domain/usecases/delete_all_cart.dart';
import 'package:shopping_app/features/cart/domain/usecases/delete_from_cart.dart';
import 'package:shopping_app/features/cart/domain/usecases/get_from_cart.dart';
import 'package:shopping_app/features/cart/domain/usecases/increase_count.dart';
import 'package:shopping_app/features/cart/domain/usecases/is_in_cart.dart';

class CartProvider with ChangeNotifier {
  final CartRepository cartRepo;
  final AddToCart _addToCart;
  final GetFromCart _getFromCart;
  final DeleteFromCart _deleteFromCart;
  final IsInCart _isInCart;
  final IncreaseCount _increaseCount;
  final DecreaseCount _decreaseCount;
  final DeleteAllCart _deleteAllCart;
  CartProvider(this.cartRepo)
    : _addToCart = AddToCart(cartRepo),
      _getFromCart = GetFromCart(cartRepo),
      _deleteFromCart = DeleteFromCart(cartRepo),
      _isInCart = IsInCart(cartRepo),
      _increaseCount = IncreaseCount(cartRepo),
      _decreaseCount = DecreaseCount(cartRepo),
      _deleteAllCart = DeleteAllCart(cartRepo);

  // int itemCount = 1;
  List<CartEntity> cartItems = [];

  bool addToCartLoading = false;
  String? addToCartError;
  bool getCartLoading = false;
  String? getCartError;

  bool? isInCart;

  void isAlreadyInCart(String productId) {
    isInCart = _isInCart(productId);
    notifyListeners();
  }

  Future<void> addToCart(CartEntity entity) async {
    try {
      addToCartLoading = true;
      notifyListeners();
      await _addToCart(entity);
      final items = await _getFromCart();
      cartItems = List.from(items);
      addToCartError = null;
    } catch (e) {
      addToCartError = e.toString();
    } finally {
      addToCartLoading = false;
      isAlreadyInCart(entity.product.id!);
      notifyListeners();
    }
  }

  Future<void> getFromCart() async {
    cartItems = await _getFromCart();
    notifyListeners();
  }

  Future<void> deleteFromCart(int key) async {
    await _deleteFromCart(key);
    final items = await _getFromCart();
    cartItems = List.from(items);
    notifyListeners();
  }

  Future<void> deleteAllCart() async {
    await _deleteAllCart();
    final items = await _getFromCart();
    cartItems = List.from(items);
    notifyListeners();
  }

  Future<void> increaseCount(int productId) async {
    await _increaseCount(productId);
    final items = await _getFromCart();
    cartItems = List.from(items);
    notifyListeners();
  }

  Future<void> decreaseCount(int productId) async {
    await _decreaseCount(productId);
    final items = await _getFromCart();
    cartItems = List.from(items);
    notifyListeners();
  }

  double get totalAmount {
    return cartItems.fold(0.0, (sum, item) {
      return sum + (item.product.price ?? 0.0) * item.count;
    });
  }
}
