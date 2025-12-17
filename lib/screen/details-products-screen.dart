import 'package:flutter/material.dart';
import 'package:plantzone/model/products.dart';
class DetailsScreen extends StatefulWidget {
  final Product product;
  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // Danh sách ảnh sẽ hiển thị: nếu có images thì dùng, nếu không dùng image chính
    final List<String> imageUrls = widget.product.images;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: PageView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                final url = imageUrls[index];
                return Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, stackTrace) {
                    return const Center(
                      child: Text(
                        'Không thể tải ảnh',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
