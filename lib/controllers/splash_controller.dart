import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intagramclone/pages/HomePage/home_page.dart';
import 'package:intagramclone/pages/sign_in_page.dart';
import 'package:intagramclone/service/pref_service.dart';
import 'package:intagramclone/service/utils.dart';

class SplashController extends GetxController{
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _initTimer();
    Utils.initNotification();
  }
  void _initTimer()=>
      Timer(const Duration(seconds: 2),()=>Get.to(_starterPage));


  Widget _starterPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          Prefs.store(StorageKeys.UID, snapshot.data!.uid);
          return  const HomePage();
        } else {
          Prefs.remove(StorageKeys.UID);
          return const SignInPage();
        }
      },
    );
  }
}