import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:plantzone/model/products.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:plantzone/providers/cart-provider.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;
  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = widget.product.images;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider.builder(
            itemCount: imageUrls.length,
            itemBuilder: (context, index, realIndex) {
              final url = imageUrls[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (ctx, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Text(
                            'Không thể tải ảnh',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 300,
              viewportFraction: 0.85, // Hiển thị 85% của khung hình
              enlargeCenterPage: true, // Phóng to trang hiện tại
              enlargeFactor: 0.2, // Tỷ lệ phóng to
              scrollDirection: Axis.horizontal,
              pageSnapping: true, // Tự động dừng ở trang gần nhất
              enableInfiniteScroll: true, // Vòng lặp vô hạn
            ),
          ),
          // Tên và giá
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${widget.product.name}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${NumberFormat('#,##0').format(widget.product.price)}đ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),

          // Đánh giá
          Row(
            children: [
              RatingBarIndicator(
                rating: widget.product.rating,
                itemBuilder: (context, index) =>
                    Icon(Icons.star, color: Colors.amber),
                itemSize: 30,
              ),
              SizedBox(width: 8),
              Text('(${widget.product.rating})'),
            ],
          ),
          // Mô tả
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Mô tả', style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${widget.product.description}', maxLines: 3),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Kích thước',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Kích thước lựa chọn
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('50 cm', textAlign: TextAlign.center),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('70 cm', textAlign: TextAlign.center),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('100 cm', textAlign: TextAlign.center),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Khác', textAlign: TextAlign.center),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý mua ngay
                },
                child: Text(
                  'Mua ngay',
                  style: TextStyle(color: Colors.red),
                  ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý thêm vào giỏ hàng
                  context.read<CartProvider>().addToCart(widget.product);
                  // Hiển thị thông báo
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm vào giỏ hàng'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text(
                  'Thêm vào giỏ hàng',
                  
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
