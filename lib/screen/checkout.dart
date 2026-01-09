import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Cần import để định dạng tiền tệ
import '../model/cart_model.dart';
import '../model/cart_service.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final CartService _cartService = CartService();

  int _selectedPaymentIndex = 0;

  final Color primaryColor = const Color(0xFF1E6F5C);
  final Color priceColor = const Color(0xFF009688);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thanh toán',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      // Dùng StreamBuilder để lắng nghe dữ liệu từ giỏ hàng
      body: StreamBuilder<List<CartModel>>(
        stream: _cartService.getCartStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có sản phẩm để thanh toán"));
          }

          final cartItems = snapshot.data!;

          // Tính toán tổng tiền hàng (Tạm tính)
          double subTotal = 0;
          for (var item in cartItems) {
            subTotal += item.price * item.quantity;
          }

          // Phí ship và giảm giá
          double shippingFee = 30000;
          double discount = 0; // Ví dụ: Chưa áp mã

          // Tổng thanh toán cuối cùng
          double finalPrice = subTotal + shippingFee - discount;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddressSection(),
                    const SizedBox(height: 16),
                    // Truyền danh sách cartItems vào để hiển thị
                    _buildProductListSection(cartItems),
                    const SizedBox(height: 16),
                    _buildVoucherSection(),
                    const SizedBox(height: 16),
                    _buildPaymentMethodSection(), // Đã cập nhật logic chọn
                    const SizedBox(height: 16),
                    // Truyền các giá trị đã tính toán vào để hiển thị
                    _buildPaymentDetailsSection(subTotal, shippingFee, discount, finalPrice),
                    const SizedBox(height: 24),
                    _buildFooterTerms(),
                    const SizedBox(height: 100), // Khoảng trống cho nút đặt hàng
                  ],
                ),
              ),
              // Nút đặt hàng ghim dưới đáy
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomButton(finalPrice),
              ),
            ],
          );
        },
      ),
    );
  }

  // CÁC WIDGET CON

  Widget _buildAddressSection() {
    // Phần này giữ nguyên giao diện mẫu
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: primaryColor),
                  const SizedBox(width: 8),
                  const Text(
                    'Địa chỉ giao hàng',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text('Thay đổi', style: TextStyle(color: primaryColor)),
              )
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nguyễn Văn A',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                const Text('0912 345 678', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                const Text(
                  '123 Nguyễn Huệ, Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh',
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Nhận vào List<CartModel>
  Widget _buildProductListSection(List<CartModel> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sản phẩm đã chọn (${items.length})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          // Dùng ListView.separated hoặc Column + map để hiển thị danh sách động
          ...items.map((item) {
            double itemTotal = item.price * item.quantity;
            return Column(
              children: [
                _buildProductItem(
                  item.name,
                  'SL: ${item.quantity}', // Hiển thị số lượng
                  '${NumberFormat('#,##0').format(item.price)} ₫',
                  '${NumberFormat('#,##0').format(itemTotal)} ₫',
                  item.image,
                ),
                const Divider(height: 24),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildProductItem(String name, String variant, String unitPrice, String totalPrice, String imgUrl) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imgUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(variant, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 4),
              Text(unitPrice, style: TextStyle(color: priceColor, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(totalPrice, style: TextStyle(color: priceColor, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildVoucherSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(Icons.local_offer_outlined, color: primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Nhập mã giảm giá',
                border: InputBorder.none,
                isDense: true,
              ),
              controller: TextEditingController(text: "NEWUSER30"),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Áp dụng', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  // Xử lý sự kiện chọn phương thức thanh toán
  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment, color: primaryColor),
              const SizedBox(width: 8),
              const Text('Phương thức thanh toán', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          // Truyền index vào để so sánh
          _buildPaymentOption(0, 'Ví MoMo', Icons.account_balance_wallet),
          const SizedBox(height: 12),
          _buildPaymentOption(1, 'Thẻ tín dụng/Ghi nợ', Icons.credit_card),
          const SizedBox(height: 12),
          _buildPaymentOption(2, 'Chuyển khoản ngân hàng', Icons.account_balance),
          const SizedBox(height: 12),
          _buildPaymentOption(3, 'Thanh toán khi nhận hàng', Icons.money),
        ],
      ),
    );
  }

  // Thêm InkWell và logic setState
  Widget _buildPaymentOption(int index, String title, IconData icon) {
    bool isSelected = _selectedPaymentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentIndex = index; // Cập nhật trạng thái khi ấn
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.05) : Colors.white,
          border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? primaryColor : Colors.grey, size: 24),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal))),
            if (isSelected) Icon(Icons.check_circle, color: primaryColor, size: 20),
          ],
        ),
      ),
    );
  }

  // Nhận giá trị tính toán để hiển thị
  Widget _buildPaymentDetailsSection(double subTotal, double ship, double discount, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Chi tiết thanh toán', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildPriceRow('Tạm tính', '${NumberFormat('#,##0').format(subTotal)} ₫'),
          const SizedBox(height: 8),
          _buildPriceRow('Phí vận chuyển', '${NumberFormat('#,##0').format(ship)} ₫'),
          const SizedBox(height: 8),
          _buildPriceRow('Giảm giá', '-${NumberFormat('#,##0').format(discount)} ₫', isDiscount: true),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng cộng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('${NumberFormat('#,##0').format(total)} ₫', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: priceColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String price, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(price, style: TextStyle(color: isDiscount ? Colors.red : Colors.black87, fontWeight: isDiscount ? FontWeight.w500 : FontWeight.normal)),
      ],
    );
  }

  Widget _buildFooterTerms() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text.rich(
        TextSpan(
          text: 'Bằng việc tiếp tục thanh toán, bạn đồng ý với \n',
          style: TextStyle(fontSize: 12, color: Colors.grey),
          children: [
            TextSpan(
              text: 'Điều khoản dịch vụ',
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' và '),
            TextSpan(
              text: 'Chính sách bảo mật',
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' của chúng tôi.'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Hiển thị giá tổng thực tế trên nút
  Widget _buildBottomButton(double finalPrice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Xử lý logic đặt hàng
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Đặt hàng thành công với phương thức: ${_selectedPaymentIndex == 0 ? "MoMo" : "Khác"}'))
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
            'Đặt hàng • ${NumberFormat('#,##0').format(finalPrice)} ₫',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
        ),
      ),
    );
  }
}