import 'package:flutter/material.dart';
import '../components/field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController password = TextEditingController();
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

                Field(icon: Icon(Icons.email), isPassword: false,hintText: 'Email'),
                SizedBox(height: 20),

                Field(icon: Icon(Icons.lock), isPassword: true, hintText: 'Password'),
                SizedBox(height: 20),

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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

