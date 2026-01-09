import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color primaryColor = const Color(0xFF5E9E76);
  final Color backgroundColor = const Color(0xFFF5F5F5);
  final Color redColor = const Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Phần Header xanh và thẻ thống kê
            _buildHeaderSection(),
            const SizedBox(height: 20),
            // 2. Phần Đơn hàng
            _buildOrderSection(),
            const SizedBox(height: 20),
            // 3. Phần Thông tin
            _buildInfoSection(),
            const SizedBox(height: 20),
            // 4. Phần Cài đặt (MỚI BỔ SUNG)
            _buildSettingsSection(),
            const SizedBox(height: 30),
            // 5. Nút Đăng xuất (MỚI BỔ SUNG)
            _buildLogoutButton(),
            const SizedBox(height: 20),
            // 6. Thông tin phiên bản (MỚI BỔ SUNG)
            _buildVersionInfo(),
            const SizedBox(height: 40), // Khoảng trống an toàn dưới cùng
          ],
        ),
      ),
    );
  }


  // HEADER & THẺ THỐNG KÊ ---
  Widget _buildHeaderSection() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Nền xanh gradient
        Container(
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [primaryColor.withOpacity(0.9), primaryColor],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        // Nội dung User
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.white24,
                    ),
                    child: const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nguyễn Văn A",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "nguyenvana@email.com",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.emoji_events, color: Colors.amber, size: 16),
                            SizedBox(width: 5),
                            Text("Thành viên Vàng", style: TextStyle(color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        // Thẻ thống kê nổi
        Positioned(
          bottom: -40,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard("350", "Điểm thưởng"),
              _buildStatCard("12", "Đơn hàng"),
              _buildStatCard("28", "Yêu thích"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  // KHỐI ĐƠN HÀNG
  Widget _buildOrderSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Đơn hàng", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                _buildMenuItem(icon: Icons.inventory_2_outlined, iconColor: primaryColor, title: "Đơn hàng của tôi", trailingText: "12"),
                const Divider(height: 1, indent: 60, endIndent: 20, color: Colors.grey),
                _buildMenuItem(icon: Icons.favorite_border, iconColor: redColor, title: "Yêu thích", trailingText: "28"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // KHỐI THÔNG TIN
  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Thông tin", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                _buildMenuItem(icon: Icons.person_outline, iconColor: primaryColor, title: "Thông tin cá nhân"),
                const Divider(height: 1, indent: 60, endIndent: 20, color: Colors.grey),
                _buildMenuItem(icon: Icons.location_on_outlined, iconColor: primaryColor, title: "Địa chỉ giao hàng"),
                const Divider(height: 1, indent: 60, endIndent: 20, color: Colors.grey),
                _buildMenuItem(icon: Icons.credit_card, iconColor: primaryColor, title: "Phương thức thanh toán"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // KHỐI CÀI ĐẶT
  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Cài đặt", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                _buildMenuItem(icon: Icons.notifications_none, iconColor: primaryColor, title: "Thông báo"),
                const Divider(height: 1, indent: 60, endIndent: 20, color: Colors.grey),
                _buildMenuItem(icon: Icons.help_outline, iconColor: primaryColor, title: "Trợ giúp & Hỗ trợ"),
                const Divider(height: 1, indent: 60, endIndent: 20, color: Colors.grey),
                _buildMenuItem(icon: Icons.settings_outlined, iconColor: primaryColor, title: "Cài đặt"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // NÚT ĐĂNG XUẤT
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () {
          // Xử lý đăng xuất
          print("Đăng xuất");
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: redColor),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: redColor),
              const SizedBox(width: 10),
              Text(
                "Đăng xuất",
                style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // THÔNG TIN PHIÊN BẢN
  Widget _buildVersionInfo() {
    return const Center(
      child: Text(
        "Phiên bản 1.0.0",
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }

  // DÒNG MENU
  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? trailingText,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(trailingText, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
            ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }
}