import 'package:flutter/material.dart';
import 'package:plantzone/providers/bottom-provider.dart';
import 'package:plantzone/providers/cart-provider.dart';
import 'package:plantzone/screen/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantzone/screen/mainscreen.dart';
import 'package:plantzone/shared%20preferences/user_shared_preferences.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Khởi tạo init()
  await UserPrefs.init();
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => BottomNavProvider()),
          ChangeNotifierProvider(create: (context) => CartProvider()),
        ],
        child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserPrefs.getUser();
    final bool isLoginIn = user != null;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoginIn ? const MainScreen() : const LoginScreen(),
    );
  }
}

