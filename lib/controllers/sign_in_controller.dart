import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intagramclone/pages/HomePage/home_page.dart';
import 'package:intagramclone/service/auth_service.dart';
import 'package:intagramclone/service/pref_service.dart';
import 'package:intagramclone/service/utils.dart';

class SignInPageController extends GetxController{
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Utils.initNotification();
  }
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showError = true;
  bool isLoading = false;


  callHomePage(context) async {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    showError = false;
    update();
    if (email.isEmpty || password.isEmpty) {
      Utils.fireSnackBar("Please complete all the fields", context);
      return;
    }
    if (!Validation.validationEmail(email) &&
        !Validation.validationPassword(password)) {
      if (!Validation.validationEmail(email)) {
        update();
      }

      return;
    }

    isLoading = true;
    update();
    await AuthService.signInUser(email, password).then((response) {
      _getFirebaseUser(context,response);
    });
  }

  void _getFirebaseUser(context,Map<String, User?> map) async {
    isLoading = false;
    update();
    if(!map.containsKey("SUCCESS")) {
      if(map.containsKey("user-not-found")) Utils.fireSnackBar("No user found for that email.", context);
      if(map.containsKey("wrong-password")) Utils.fireSnackBar("Wrong password provided for that user.", context);
      if(map.containsKey("ERROR")) Utils.fireSnackBar("Check Your Information.", context);
      return;
    }
    User? user = map["SUCCESS"];
    if(user == null) return;

    await Prefs.store(StorageKeys.UID, user.uid);
    //Navigator.pushReplacementNamed(context, HomePage.id);
    Get.to(const HomePage());
  }
}