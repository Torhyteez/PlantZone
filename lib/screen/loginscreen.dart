import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantzone/screen/mainscreen.dart';
import 'package:plantzone/screen/signup_screen.dart';
import '../components/field.dart';
import '../model/user.dart';
import '../shared preferences/user_shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController password = TextEditingController();

  // Hàm xử lý đăng nhập
  Future<void> handleLogin(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lấy đối tượng User từ kết quả trả về
      final User? firebaseUser = credential.user;

      if (firebaseUser != null) {

        // Lấy UID
        String uid = firebaseUser.uid;

        // Lấy Email
        String email = firebaseUser.email ?? "";

        // Lấy Tên hiển thị
        String name = firebaseUser.displayName ?? "No Name";

        // Lấy Token
        // forceRefresh: false nghĩa là lấy token từ cache nếu còn hạn
        String token = await firebaseUser.getIdToken() ?? "";

        UserModel myUser = UserModel(
          id: uid,
          name: name,
          email: email,
          token: token,
        );

        // Lưu vào SharedPreferences
        await UserPrefs.saveUser(myUser);

        print("Đã lưu User thành công: ${myUser.id}");
      }
    } on FirebaseAuthException catch (e) {
      print("Lỗi đăng nhập: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'images/loginscreen.jpg',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PlantZone',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  'Mang thiên nhiên đến ngôi nhà của bạn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),

                Field(
                  icon: Icon(Icons.email),
                  isPassword: false,
                  hintText: 'Email',
                  controller: emailController,
                ),
                SizedBox(height: 20),

                Field(
                  icon: Icon(Icons.lock),
                  isPassword: true,
                  hintText: 'Password',
                  controller: password,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/facebook.png',
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 10),
                    Image.asset(
                      'images/google.png',
                      width: 45,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    // Kiểm tra nhập liệu
                    if (emailController.text.isEmpty || password.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Vui lòng nhập đầy đủ Email và Mật khẩu',
                          ),
                        ),
                      );
                      return;
                    }

                    // Xử lý đăng nhập
                    await handleLogin(emailController.text, password.text);

                    // Chuyển sang trang Main
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Text(textAlign: TextAlign.center, 'Login'),
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chưa có tài khoản?',
                      style: TextStyle(
                        color:
                            Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Chuyển sang trang Đăng ký
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Đăng ký',
                        style: TextStyle(
                          color:
                              Colors.greenAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration
                              .underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


