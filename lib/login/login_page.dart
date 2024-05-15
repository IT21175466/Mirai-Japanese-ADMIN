import 'package:firebase_auth/firebase_auth.dart';
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

  bool isLoading = false;

  Future<void> login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          )
          .then((value) => {
                isLoading = false,
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'User not found with this email!',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'wrong-password') {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Wrong Password!',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        color: Color.fromARGB(255, 234, 242, 255),
        child: Column(
          children: [
            Spacer(),
            Container(
              height: screenHeight / 2,
              width: screenWidth / 3.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.borderColor,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: screenWidth / 3.5,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.borderColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Admin Login',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextField(
                        controller: emailController, labelText: 'Email'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextField(
                        controller: passwordController, labelText: 'Password'),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  isLoading
                      ? Container(
                          height: 50,
                          width: screenWidth / 3.5,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Please enter details!",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              login();
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: CustomButton(
                                text: 'Login',
                                height: 50,
                                width: screenWidth / 3.5),
                          ),
                        ),
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
