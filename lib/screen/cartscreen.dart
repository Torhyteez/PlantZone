import 'package:flutter/material.dart';
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/plant${index+1}.jpg'),
              ),
              title: Text('Plant Item ${index+1}'),
              subtitle: Text('Quantity: 1'),
              trailing: Text('\$${(index + 1) * 10}'),
            );
          }
          ),
        ) 
    );
  }
}
