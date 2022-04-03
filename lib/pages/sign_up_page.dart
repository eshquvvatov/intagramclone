import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intagramclone/controllers/sign_up_controller.dart';
import 'package:intagramclone/pages/sign_in_page.dart';
import 'package:intagramclone/service/utils.dart';
import 'package:intagramclone/views/sign_in_view.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const id = "/sign_up_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utils.initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<SignUpPageController>(
            init: SignUpPageController(),
            builder: (_controller) {
              return SingleChildScrollView(
                child: Stack(
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
                                    text: "Fullname",
                                    controller: _controller.fullNameController,
                                    fields: ErrorFields.FullName,
                                    showError: _controller.showError),
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
                                InputText(
                                    text: "Confirm Password",
                                    controller: _controller.confirmController,
                                    fields: ErrorFields.Confirm,
                                    password:
                                        _controller.passwordController.text,
                                    showError: _controller.showError),
                                const SizedBox(
                                  height: 10,
                                ),
                                MaterialButton(
                                  splashColor: Colors.white,
                                  onPressed: () {
                                    _controller.callSignIn(context);
                                  },
                                  child: const Text(
                                    "Sign Up",
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
                                  text: "Already have an account?  ",
                                ),
                                TextSpan(
                                  text: "Sign In",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(SignInPage());
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
                ),
              );
            }));
  }



}
