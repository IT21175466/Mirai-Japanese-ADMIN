import 'package:flutter/material.dart';
import 'package:mirai_japanese_admin/constaints/app_colors.dart';
import 'package:mirai_japanese_admin/widgets/custom_button.dart';
import 'package:mirai_japanese_admin/widgets/textfiled.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Login',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.borderColor,
      ),
      body: Container(
        height: screenHeight - AppBar().preferredSize.height,
        width: screenWidth,
        color: Color.fromARGB(255, 234, 242, 255),
        child: Column(
          children: [
            Spacer(),
            Container(
              height: screenHeight / 2,
              width: screenWidth / 3.5,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.borderColor,
                ),
              ),
              child: Column(
                children: [
                  Spacer(),
                  SizedBox(
                    height: 60,
                    child: Image.asset('assets/images/splashLogo.png'),
                  ),
                  Spacer(),
                  CustomTextField(
                      controller: emailController, labelText: 'Email'),
                  CustomTextField(
                      controller: passwordController, labelText: 'Password'),
                  SizedBox(
                    height: 25,
                  ),
                  CustomButton(
                      text: 'Login', height: 50, width: screenWidth / 3.5),
                  Spacer(),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              height: 60,
              child: Image.asset('assets/images/logo.png'),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
