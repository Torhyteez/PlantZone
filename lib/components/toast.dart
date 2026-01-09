import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static late FToast fToast;

  // Hàm
  static void init(BuildContext context) {
    fToast = FToast();
    fToast.init(context);
  }

  static void showToast(BuildContext context) {
    Widget toastUI = Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.black.withOpacity(0.8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_circle_outline, color: Colors.white, size: 30),
          SizedBox(height: 8),
          Text(
            'Thành công',
            style: TextStyle(color: Colors.white, fontSize: 14),
          )
        ],
      ),
    );
    fToast.showToast(
        child: toastUI,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 2),
      fadeDuration: const Duration(milliseconds: 1)
    );
  }
}