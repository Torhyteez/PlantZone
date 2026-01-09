class CartModel {
  final String productId;
  final String name;
  final String image;
  final double price;
  final int quantity;

  CartModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  // Chuyển từ Firestore Document sang Object
  factory CartModel.fromMap(Map<String, dynamic> data) {
    return CartModel(
      productId: data['productId'] ?? '',
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 1,
    );
  }

  // Chuyển từ Object sang Map để đẩy lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }
}