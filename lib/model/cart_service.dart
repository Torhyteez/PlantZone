import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_model.dart';

class CartService {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart(CartModel product) async {
    if (userId == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(product.productId);

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      await docRef.update({
        'quantity': FieldValue.increment(product.quantity),
      });
    } else {
      await docRef.set(product.toMap());
    }
  }

  Stream<List<CartModel>> getCartStream() {
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots() // Lắng nghe thay đổi
        .map((snapshot) => snapshot.docs
        .map((doc) => CartModel.fromMap(doc.data()))
        .toList());
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    if (userId == null) return;
    if (newQuantity < 1) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(productId)
        .update({'quantity': newQuantity});
  }

  Future<void> removeFromCart(String productId) async {
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(productId)
        .delete();
  }
}