import 'package:flutter/material.dart';
import 'package:plantzone/providers/cart-provider.dart';
import 'package:provider/provider.dart';
import 'package:plantzone/model/cart_item.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<CartItem> _displayedItems = [];
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadMoreItems();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreItems() {
    final cartProvider = context.read<CartProvider>();
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    final newItems = cartProvider.cartItems.sublist(
      startIndex,
      endIndex > cartProvider.cartItems.length
          ? cartProvider.cartItems.length
          : endIndex,
    );
    setState(() {
      _displayedItems.addAll(newItems);
      _currentPage++;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _loadMoreItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: cartProvider.cartItems.isEmpty
            ? Center(child: Text('Giỏ hàng trống'))
            : ListView.builder(
                itemCount: cartProvider.cartItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    borderOnForeground: true,
                    elevation: 4,
                    margin: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              cartProvider.cartItems[index].product.image,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              cartProvider.cartItems[index].product.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${NumberFormat('#,##0').format(cartProvider.cartItems[index].product.price * cartProvider.cartItems[index].quantity)} đ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              alignment: Alignment.topRight,
                              onPressed: () {
                                cartProvider.removeFromCart(
                                  cartProvider.cartItems[index],
                                );
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                            Container(
                              height: 40,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      cartProvider.updateQuantity(
                                        cartProvider.cartItems[index],
                                        cartProvider.cartItems[index].quantity -
                                            1,
                                      );
                                    },
                                    icon: Icon(Icons.remove),
                                  ),
                                  Text(
                                    '${cartProvider.cartItems[index].quantity}',
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      cartProvider.updateQuantity(
                                        cartProvider.cartItems[index],
                                        cartProvider.cartItems[index].quantity +
                                            1,
                                      );
                                    },
                                    icon: Icon(Icons.add),
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
        bottomNavigationBar: Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Tóm tắt đơn hàng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Tạm tính: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '${NumberFormat('#,##0').format(cartProvider.totalPrice)}đ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Phí vận chuyển: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '25,000đ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Giảm giá: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '0đ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Tạm tính: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '${NumberFormat('#,##0').format(cartProvider.totalPrice + 25000)}đ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
