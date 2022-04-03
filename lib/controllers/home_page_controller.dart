import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intagramclone/service/utils.dart';

class HomePageController extends GetxController{

  late PageController pageController ;
  int currentIndex=0;


  initNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("Message: ${message.notification.toString()}");
      }
      Utils.showLocalNotification(message);
    });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   Utils.showLocalNotification(message);
    // });
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    pageController=PageController();
    Utils.initNotification();
  }

}