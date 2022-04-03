import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intagramclone/model/user_model.dart' as model;
import 'package:intagramclone/pages/sign_in_page.dart';
import 'package:intagramclone/service/auth_service.dart';
import 'package:intagramclone/service/data_service.dart';
import 'package:intagramclone/service/pref_service.dart';
import 'package:intagramclone/service/utils.dart';


class SignUpPageController extends GetxController{
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Utils.initNotification();
  }
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  String failEmail = "Field don't empty.";
  String failPassword = "Field don't empty.";
  bool showError = true;
  bool isLoading = false;

  callSignIn(context) async {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String fullName = fullNameController.text.toString().trim();
    String confirm = confirmController.text.toString().trim();
    showError = false;
    update();
    if (email.isEmpty ||
        password.isEmpty ||
        fullName.isEmpty ||
        confirm.isEmpty) {
      return;
    }

    if (!Validation.validationEmail(email) ||
        !Validation.validationPassword(password) ||
        fullName.isEmpty ||
        confirm != password) {
      return;
    }
    isLoading = true;
    update();
    var modelUser = model.User(password: password, email: email, fullName:  fullName);
    await AuthService.signUpUser(fullName, email, password).then((response) {
      _getFirebaseUser(context,modelUser,response);
    });
  }

  void _getFirebaseUser(context,model.User modelUser,  Map<String, User?> map) async {
    isLoading = false;
    update();
    if(!map.containsKey("SUCCESS")) {
      if(map.containsKey("weak-password")) Utils.fireSnackBar("The password provided is too weak.", context);
      if(map.containsKey("email-already-in-use")) Utils.fireSnackBar("The account already exists for that email.", context);
      if(map.containsKey("ERROR")) Utils.fireSnackBar("Check Your Information.", context);
      return;
    }
    User? user = map["SUCCESS"];
    if(user == null) return;

    await Prefs.store(StorageKeys.UID, user.uid);
    modelUser.uid = user.uid;
    DataService.storeUser(modelUser).then((value) => {
      Get.to(const SignInPage())
    }
     // Navigator.pushReplacementNamed(context, SignInPage)}
      );
  }
}