import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intagramclone/pages/HomePage/home_page.dart';
import 'package:intagramclone/pages/sign_in_page.dart';
import 'package:intagramclone/service/pref_service.dart';
import 'package:intagramclone/service/utils.dart';

import '../service/incription.dart';

class Users {
  int? id;
  String? holderName;
  String? cardNumber;

  Users(this.id, this.holderName, this.cardNumber);

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    holderName = json['holderName'];
    cardNumber = json['cardNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['holderName'] = this.holderName;
    data['cardNumber'] = this.cardNumber;
    return data;
  }

  @override
  String toString() {
    return 'User{id: $id, holderName: $holderName, cardNumber: $cardNumber}';
  }
}

class SplashController extends GetxController {
  /// secerute

  void testSymmetric1() {
    var user = Users(1, "eshquvatov", "9898989898797");
    print(user);
    user.cardNumber = Symmetric.encrypt(user.cardNumber);
    print(user);

    var cardNumber = Symmetric.decrypt(user.cardNumber);
    user.cardNumber = cardNumber;
    print(user);
  }
  void testSymmetric2() {
    var user = Users(1, "eshquvatov", "9898989898797");

    var userString = user.toString();
    print(userString);

    var userEncreption = Symmetric.encrypt(userString);
    print(userEncreption);

    var userDecrypt = Symmetric.decrypt(userEncreption);
    print(userEncreption);

    //var user2 = Users.fromJson(userDecrypt);
    print(userDecrypt);
  }
//   void testAsymmetric1() async{
//     var user = Users(1, "eshquvatov", "9898989898797");
//     print(user);
//     var cardNumber =await Assemetric.encrypt(user.cardNumber!);
//     print(cardNumber);
// print("**************************************************");
//      cardNumber =await Assemetric.decrypt(cardNumber);
//     print(cardNumber);
//   }
void testAsymmetric3(){
      var user = Users(1, "eshquvatov", "9898989898797");
      print("------------------------------------------------- boshlandi");

      var cardNumber = Assemetric2.encrypt("eshquvatov");
    print(cardNumber);
print("**************************************************");
     cardNumber = Assemetric2.decrypt(cardNumber);
    print(cardNumber);
}


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // testSymmetric1();
    // testSymmetric2();
    testAsymmetric3();
    _initTimer();
    Utils.initNotification();
  }

  void _initTimer() =>
      Timer(const Duration(seconds: 2), () => Get.to(_starterPage));

  Widget _starterPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Prefs.store(StorageKeys.UID, snapshot.data!.uid);
          return const HomePage();
        } else {
          Prefs.remove(StorageKeys.UID);
          return const SignInPage();
        }
      },
    );
  }
}
