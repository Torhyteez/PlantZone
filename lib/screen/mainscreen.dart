import 'package:flutter/material.dart';
import 'package:plantzone/providers/bottom-provider.dart';
import 'package:plantzone/screen/cartscreen.dart';
import 'package:plantzone/screen/homescreen.dart';
import 'package:plantzone/screen/profilescreen.dart';
import 'package:provider/provider.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    Homescreen(),
    CartScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    // Lấy giá trị index từ provider
    final selectedIndex = context.watch<BottomNavProvider>().currentIndex;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 4,
        leading: Icon(Icons.ac_unit),
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.notifications)
          ),

        ],
        title: Container(
          child: TextField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0)
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Profile'
            )
          ],
        currentIndex: selectedIndex,
        onTap: (index) {
            context.read<BottomNavProvider>().updateIndex(index);
        },
      ),
    );
  }
}
