import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantzone/model/cart_service.dart';
import 'package:plantzone/model/products.dart';
import 'package:plantzone/screen/details-products-screen.dart';
import 'package:intl/intl.dart';

import '../model/cart_model.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Image> images = [
    Image.asset('images/leaf.png'),
    Image.asset('images/briefcase.png'),
    Image.asset('images/succulent.png'),
    Image.asset('images/cactus.png'),
  ];
  List<String> names = ['Tất cả', 'Cây văn phòng', 'Sen đá', 'Xương rồng'];
  // Danh sách chứa sản phẩm sẽ hiển thị
  final List<Product> _products = [];
  bool _isLoading = false;
  // Biến kiểm tra xem còn dữ liệu để tải không
  bool _hasMore = true;
  // Lưu trữ document cuối cùng đã tải
  DocumentSnapshot? _lastDocument;
  final int _itemsPerPage = 20;
  final ScrollController _scrollController = ScrollController();

  // Hàm goi firestore
  Future<void> _getProducts() async {
    if (!_isLoading && !_hasMore) return;
    setState(() {
      _isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('products')
        .orderBy('name')
        .limit(_itemsPerPage);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    try {
      QuerySnapshot snapshot = await query.get();
      if (snapshot.docs.isEmpty) {
        setState(() {
          _hasMore = false;
          _isLoading = false;
        });
        return;
      }
      // Cập nhật document cuối cùng
      _lastDocument = snapshot.docs.last;

      // Chuyển đổi data sang Model và thêm vào danh sách hiện tại
      List<Product> newProducts = snapshot.docs
          .map((doc) => Product.fromSnapshot(doc))
          .toList();
      setState(() {
        _products.addAll(newProducts);
        _isLoading = false;
      });
      // Kiểm tra xem còn dữ liệu để tải không
      if (snapshot.docs.length < _itemsPerPage) {
        setState(() {
          _hasMore = false;
        });
      }
    } catch (e) {
      print('Lỗi tải dữ liệu: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getProducts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        _getProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              textAlign: TextAlign.start,
              'Danh Mục',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 70,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Image(image: images[index].image, width: 30),
                      SizedBox(width: 10),
                      Text(names[index]),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 20),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.start,
                  'Nổi bật',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Xem tất cả',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          Expanded(
            child: _products.isEmpty && _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty && !_hasMore
                ? Center(child: Text('Không có sản phẩm nào'))
                : Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                          itemCount: _products.length,
                          controller: _scrollController,
                          padding: EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return GestureDetector(
                              onTap: () {
                                // Xử lý khi người dùng ấn vào sản phẩm
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsScreen(product: product),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Ảnh sản phẩm
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        child: Image.network(
                                          product.image,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (ctx, error, stackTrace) {
                                                return Center(
                                                  child: Text(
                                                    'Không thể tải ảnh',
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                    ),
                                    // Thông tin
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 5),

                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.star_rate_rounded,
                                                  color: Colors.amber,
                                                  size: 20,
                                                ),

                                                SizedBox(width: 4),

                                                Text(
                                                  '${product.rating} đ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF333333),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              // Chỉnh định dạng tiền là việt nam
                                              Text(
                                                '${NumberFormat('#,##0').format(product.price)} đ',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                ),
                                              ),
                                              Spacer(),

                                              // Ví dụ nút bấm
                                              IconButton(
                                                  onPressed: () async {
                                                    CartModel newItem = CartModel(
                                                        productId: product.id,
                                                        name: product.name,
                                                        image: product.image,
                                                        price: product.price,
                                                        quantity: 1
                                                    );
                                                    await CartService().addToCart(newItem);
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text('Đã thêm vào giỏ hàng thành công!'), backgroundColor: Colors.green)
                                                      );
                                                    }
                                                  }, 
                                                  icon: Icon(Icons.add_shopping_cart)
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (_isLoading)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
