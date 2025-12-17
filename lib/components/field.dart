import 'package:flutter/material.dart';
class Field extends StatefulWidget {
  final Icon icon;
  final bool isPassword;
  final String hintText;
  const Field({super.key, required this.icon, required this.isPassword, required this.hintText});

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20), // Thêm padding cho đẹp
      child: TextField(
        obscureText: widget.isPassword ? _isObscure : false,
        cursorColor: Colors.white,

        style: TextStyle(color: Colors.white), // Màu chữ khi gõ
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.white70, // Màu chữ gợi ý mờ hơn chút
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),

          prefixIcon: Icon(
            widget.icon.icon,
            color: Colors.white,
          ),
          suffixIcon: widget.isPassword ? IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ), onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          ) : null,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
      ),
    );
  }
}