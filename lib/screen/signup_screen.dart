import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantzone/screen/loginscreen.dart';
import 'package:plantzone/service/firebase_service.dart';
import '../components/field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'images/loginscreen.jpg',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PlantZone',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Mang thiên nhiên đến ngôi nhà của bạn',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  Field(icon: Icon(Icons.person), isPassword: false, hintText: 'Full Name', controller: nameController),
                  SizedBox(height: 20),
                  Field(icon: Icon(Icons.email), isPassword: false, hintText: 'Email', controller: emailController),
                  SizedBox(height: 20),
                  Field(icon: Icon(Icons.phone), isPassword: false, hintText: 'Phone', controller: phoneController),
                  SizedBox(height: 20),
                  Field(icon: Icon(Icons.lock), isPassword: true, hintText: 'Password', controller: passwordController),
                  SizedBox(height: 20),
                  Field(icon: Icon(Icons.lock), isPassword: true, hintText: 'Confirm Password', controller: confirmPasswordController),
                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/facebook.png', width: 50, fit: BoxFit.cover),
                      SizedBox(width: 10),
                      Image.asset('images/google.png', width: 45, fit: BoxFit.cover),
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () async {
                        if (passwordController.text != confirmPasswordController.text) {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mật khẩu không khớp!')));
                           return;
                        }
                        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vui lòng điền đủ thông tin!')));
                           return;
                        }

                        setState(() => isLoading = true); 

                        try {
                          await authService.value.signUp(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            name: nameController.text.trim(),
                            phone: phoneController.text.trim(),
                          );
                          final firebaseUser = authService.value.currentUser;
                          await firebaseUser?.updateDisplayName(nameController.text.trim());
                          await firebaseUser?.reload();
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đăng ký thành công!')));
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          }


                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                          }
                        } finally {
                           if(mounted) setState(() => isLoading = false); 
                        }
                      },
                      child: isLoading 
                          ? CircularProgressIndicator(color: Colors.green) 
                          : Text('Register'),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}