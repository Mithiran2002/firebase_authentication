import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:firebase_authentication/views/widgets/custom_form.dart';
import 'package:firebase_authentication/views/widgets/custom_button.dart';
import 'package:firebase_authentication/views/screens/home_screen/home_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  Future<void> authData() async {
    try {
      UserCredential _userData = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passController.text.trim());
      if (_userData.credential!.accessToken!.isNotEmpty) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
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

  @override
  Widget header() {
    return Column(
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
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        25.sp,
                      ),
                      topRight: Radius.circular(25.sp))),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
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
                              validator: (value) {},
                              hintText: 'Email or phone number',
                              controller: emailController,
                            ),
                            const Divider(
                              thickness: 0.6,
                              color: Colors.black54,
                            ),
                            CustomForm(
                              validator: (value) {},
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
                      text: "Login",
                      ontab: () async {
                        await authData();
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
                        onPressed: () {})
                  ],
                ),
              )),
        )
      ],
    );
  }
}
