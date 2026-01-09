import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/cart_model.dart';
import '../model/cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],

        body: StreamBuilder<List<CartModel>>(
          stream: _cartService.getCartStream(),
          builder: (context, snapshot) {
            // Xử lý trạng thái đang tải hoặc lỗi
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Lỗi: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Giỏ hàng trống'));
            }

            // Lấy dữ liệu danh sách sản phẩm
            final cartItems = snapshot.data!;

            // Tính tổng tiền đơn hàng
            double totalPrice = 0;
            for (var item in cartItems) {
              totalPrice += item.price * item.quantity;
            }

            return Column(
              children: [
                // Danh sách sản phẩm
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        borderOnForeground: true,
                        elevation: 4,
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            // Ảnh sản phẩm
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  item.image,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                            // Thông tin tên và giá
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${NumberFormat('#,##0').format(item.price * item.quantity)} đ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Các nút thao tác
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _cartService.removeFromCart(item.productId);
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove, size: 20),
                                        onPressed: () {
                                          _cartService.updateQuantity(item.productId, item.quantity - 1);
                                        },
                                      ),
                                      Text(
                                        '${item.quantity}',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add, size: 20),
                                        onPressed: () {
                                          _cartService.updateQuantity(item.productId, item.quantity + 1);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Tóm tắt đơn hàng
                _buildBottomSummary(totalPrice),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomSummary(double totalPrice) {
    double shippingFee = 25000;
    double discount = 0;
    double finalPrice = totalPrice + shippingFee - discount;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Chỉ chiếm diện tích cần thiết
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tóm tắt đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 10),
          _buildRowSummary('Tạm tính:', totalPrice),
          _buildRowSummary('Phí vận chuyển:', shippingFee),
          _buildRowSummary('Giảm giá:', discount),
          Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng cộng:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${NumberFormat('#,##0').format(finalPrice)}đ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Xử lý thanh toán
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text("Thanh toán", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRowSummary(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          Text(
            '${NumberFormat('#,##0').format(value)}đ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}