import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:plantzone/model/products.dart';
import '../model/cart_service.dart';
import '../model/cart_model.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;
  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // Khởi tạo Service
  final CartService _cartService = CartService();
  bool _isAddingToCart = false;

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách ảnh, nếu null hoặc rỗng thì dùng ảnh đại diện chính
    final List<String> imageUrls = (widget.product.images.isNotEmpty)
        ? widget.product.images
        : [widget.product.image];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Stack(
                children: [
                  CarouselSlider.builder(
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index, realIndex) {
                      final url = imageUrls[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (ctx, error, stackTrace) => Container(
                              color: Colors.grey[200],
                              child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 350,
                      viewportFraction: 0.9,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: imageUrls.length > 1,
                    ),
                  ),
                  // Nút back
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Tên và giá
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.product.name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${NumberFormat('#,##0').format(widget.product.price)}đ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            // Đánh giá
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  RatingBarIndicator(
                    rating: widget.product.rating,
                    itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                    itemSize: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '(${widget.product.rating})',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            Divider(thickness: 1, indent: 16, endIndent: 16),

            // Mô tả
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('Mô tả', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.product.description,
                style: TextStyle(color: Colors.grey[700], height: 1.5),
              ),
            ),

            SizedBox(height: 16),

            // Kích thước
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Kích thước', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            SizedBox(height: 8),

            // Phần chọn kích thước
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: ['50 cm', '70 cm', '100 cm', 'Khác'].map((size) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(size, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Khoảng trống dưới cùng để không bị nút che mất nội dung
            SizedBox(height: 80),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý mua ngay
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.red),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Mua ngay', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isAddingToCart ? null : () async {
                  setState(() => _isAddingToCart = true);

                  CartModel newItem = CartModel(
                    productId: widget.product.id,
                    name: widget.product.name,
                    image: widget.product.image,
                    price: widget.product.price,
                    quantity: 1,
                  );

                  await _cartService.addToCart(newItem);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã thêm vào giỏ hàng thành công!'), backgroundColor: Colors.green),
                    );
                    setState(() => _isAddingToCart = false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isAddingToCart
                    ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('Thêm vào giỏ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}