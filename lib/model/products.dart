import 'package:cloud_firestore/cloud_firestore.dart';
class Product {
  final String id;
  final String name;
  final double rating;
  final double price;
  final String image;
  final List<String> images;
  final String description;

  Product({
  required this.id,
  required this.name,
  required this.rating,
  required this.price,
  required this.image,
  required this.images,
  required this.description});

  factory Product.fromSnapshot(DocumentSnapshot snapshot){
    final data = snapshot.data() as Map<String, dynamic>;
    return Product(
      id: snapshot.id,
      name: data['name'] ?? 'Sản phẩm chưa đặt tên',
      price: (data['price'] ?? 0).toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      image: data['image'] ?? 'https://via.placeholder.com/150',
      images: List<String>.from(data['images'] ?? []),
      description: data['description'] ?? '',
    );
  }
}