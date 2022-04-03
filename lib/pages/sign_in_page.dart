import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intagramclone/controllers/sign_in_controller.dart';
import 'package:intagramclone/pages/HomePage/home_page.dart';
import 'package:intagramclone/pages/sign_up_page.dart';
import 'package:intagramclone/service/auth_service.dart';
import 'package:intagramclone/service/pref_service.dart';
import 'package:intagramclone/service/utils.dart';
import 'package:intagramclone/views/sign_in_view.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<SignInPageController>(
            init: SignInPageController(),
            builder: (_controller) {
              return Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(193, 53, 132, 1),
                          Color.fromRGBO(131, 58, 180, 1),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Instagram",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 45,
                                    fontFamily: "Billabong"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InputText(
                                  text: "Email",
                                  controller: _controller.emailController,
                                  fields: ErrorFields.Email,
                                  showError: _controller.showError),
                              const SizedBox(
                                height: 10,
                              ),
                              InputText(
                                  text: "Password",
                                  controller: _controller.passwordController,
                                  fields: ErrorFields.Password,
                                  showError: _controller.showError),
                              const SizedBox(
                                height: 10,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  _controller.callHomePage(context);
                                },
                                splashColor: Colors.white,
                                animationDuration: const Duration(seconds: 10),
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                      color: Colors.white,
                                      width: 3,
                                      style: BorderStyle.solid),
                                ),
                                height: 50,
                                minWidth: MediaQuery.of(context).size.width,
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            children: [
                              const TextSpan(
                                text: "Don't have an account?  ",
                              ),
                              TextSpan(
                                text: "Sign up",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacementNamed(
                                        context, SignUpPage.id);
                                  },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  if (_controller.isLoading)
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                ],
              );
            }));
  }
}
