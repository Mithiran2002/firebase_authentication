import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:firebase_authentication/views/widgets/custom_form.dart';
import 'package:firebase_authentication/views/widgets/custom_button.dart';
import 'package:firebase_authentication/views/screens/home_screen/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  Future<void> loginwithEmail() async {
    try {
      UserCredential userData =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
      print({
        'name': userData.user!.displayName,
        'email': userData.user!.email,
        'phno': userData.user!.phoneNumber
      });
      if (userData.user != null) {
        setState(() {
          isLoading = !isLoading;
        });
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeScreen(
            email: emailController.text,
            password: passController.text,
          ),
        ));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        print('The password provided is too weak.');
      } else if (e.code == "email-already-in-use") {
        print('An account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFeb5f00),
        body: header(),
      ),
    );
  }

  Widget header() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30.sp, left: 10.sp),
            child: Text("Login",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 30.sp)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.sp),
            child: Text("Welcome Back",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 20.sp)),
          ),
          Gap(8.h),
          Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        20.sp,
                      ),
                      topRight: Radius.circular(20.sp))),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Gap(2.h),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 5.h),
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFeb5f00).withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 0.5,
                                offset: const Offset(1, 5),
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.sp)),
                        child: Column(
                          children: [
                            CustomForm(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email or phone no is required";
                                }
                                return null;
                              },
                              hintText: 'Email or phone number',
                              controller: emailController,
                            ),
                            const Divider(
                              thickness: 0.2,
                              color: Colors.black54,
                            ),
                            CustomForm(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "password is required";
                                }
                                return null;
                              },
                              hintText: 'Enter the password',
                              controller: passController,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(2.h),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600),
                        )),
                    Gap(2.h),
                    CustomButton(
                      item: !isLoading
                           ? Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500),
                            )
                          : const CircularProgressIndicator(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                      ontab: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = !isLoading;
                          });
                          await loginwithEmail();
                        }
                      },
                    ),
                    Gap(6.h),
                    Text(
                      "Continue With Social Media",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    Gap(5.h),
                    SocialLoginButton(
                        width: 80.w,
                        backgroundColor: Colors.white,
                        buttonType: SocialLoginButtonType.google,
                        onPressed: () {}),
                    Gap(12.h),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
