import 'package:flutter/material.dart';
import 'package:plantzone/model/products.dart';
import 'package:plantzone/model/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];
  var totalItems = 0;

  List<CartItem> get cartItems => _cartItems;

  // Hàm thêm sản phẩm vào giỏ hàng
  void addToCart(Product product) {
    final existingItem = _cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    if (existingItem.quantity > 0) {
      existingItem.quantity++;
    } else {
      _cartItems.add(CartItem(product: product));
    }
    totalItems++;
    notifyListeners();
  }

  // Hàm tăng số lượng
  void increaseQuantity(CartItem item) {
    item.quantity++;
    totalItems++;
    notifyListeners();
  }

  // Hàm cập nhật số lượng
  void updateQuantity(CartItem item, int quantity) {
    if (quantity <= 0) {
      totalItems -= item.quantity;
      _cartItems.remove(item);
    } else {
      totalItems += (quantity - item.quantity);
      item.quantity = quantity;
    }
    notifyListeners();
  }

  // Hàm xóa sản phẩm khỏi giỏ hàng
  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    totalItems -= item.quantity;
    notifyListeners();
  }

  // Hàm xóa tất cả sản phẩm khỏi giỏ hàng
  void clearCart() {
    _cartItems.clear();
    totalItems = 0;
    notifyListeners();
  }

  // Tính tổng giá
  double get totalPrice => _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

}