import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intagramclone/service/pref_service.dart';
import 'package:intl/intl.dart';

class Utils {
  // FireSnackBar
  static fireSnackBar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey.shade400.withOpacity(0.975),
        content: Text(
          msg,
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        duration: const Duration(milliseconds: 2500),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        shape: const StadiumBorder(),
      ),
    );
  }
// notification
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static initNotification() async {
    await _firebaseMessaging
        .requestPermission(sound: true, badge: true, alert: true);
    _firebaseMessaging.getToken().then((String? token) async {
      assert(token != null);
      var deviceInfo = DeviceInfoPlugin();
      var androidDeviceInfo = await deviceInfo.androidInfo;
      int id =int.parse(DateTime.now().year.toString())+int.parse(DateTime.now().day.toString())+ int.parse(DateTime.now().second.toString());
      print("bosh");
      print(id.toString()+"**************************************************");
      print(androidDeviceInfo.brand.toString() + "++++++++++++++++++++++++++++++");
      print(androidDeviceInfo.model.toString() + "++++++++++++++++++++++++++++++");
      print(androidDeviceInfo.device.toString() + "++++++++++++++++++++++++++++++");
      print("firebase token berdi pastdagi firebase tokeni buni lakalga saqlab quyamiz ******************************");
      print(token);
      Prefs.store(StorageKeys.TOKEN, token!);
    });
  }
 static String getMonthDayYear(String date) {
    final DateTime now = DateTime.parse(date);
    final String formatted = DateFormat.yMMMMd().format(now);
    return formatted;


  }
  static Future<Map<String, String>> deviceParams() async {
    Map<String, String> params = {};
    var deviceInfo = DeviceInfoPlugin();
    String fcmToken = (await Prefs.load(StorageKeys.TOKEN))??"";

    if(Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      params.addAll({
        'device_id': iosDeviceInfo.identifierForVendor!,
        'device_type': "I",
        'device_token': fcmToken,
      });
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      int id = int.parse(DateTime.now().toString());
      print("bosh");
      print(DateTime.now().toString()+"**************************************************");
      print(androidDeviceInfo.brand.toString() + "++++++++++++++++++++++++++++++");
      print(androidDeviceInfo.model.toString() + "++++++++++++++++++++++++++++++");
      print(androidDeviceInfo.device.toString() + "++++++++++++++++++++++++++++++");
      params.addAll({
        'device_id': androidDeviceInfo.androidId!,
        'device_type': "A",
        'device_token': fcmToken,
      });
    }

    return params;
  }
  static Future<void> showLocalNotification(RemoteMessage message) async {
    String title = message.notification!.title!;
    String body = message.notification!.body!;

    // if(Platform.isAndroid){
    //   title = message['notification']['title'];
    //   body = message['notification']['body'];
    // }

    var android = const AndroidNotificationDetails('channelId', 'channelName', channelDescription: 'channelDescription');
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);

    int id = Random().nextInt((pow(2, 31) - 1).toInt());
    await FlutterLocalNotificationsPlugin().show(id, title, body, platform);
  }

  static Future<bool> dialogCommon(
      BuildContext context, String title, String message, bool isSingle) async
  {
    return await showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              if (!isSingle)
                CupertinoDialogAction(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              CupertinoDialogAction(
                child: const Text("Confirm"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("Cencel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("Confirm"),
              ),
            ],
          );
        }
      },
    );
  }

}

class Validation {
  static validationEmail(String text) {
    bool email = RegExp(r'^([a-zA-z\d\.\-\_]+)@[a-z]+\.[a-z]+(\.[a-z]+)?$')
        .hasMatch(text);
    return email;
  }

  static validationPassword(String text) {
    if (text.length >= 6) {
      return true;
    }
    return false;
  }

  static ErrorText(
      {required ErrorFields fields,
      required String text,
      String? password}) {
    switch (fields) {
      case ErrorFields.Email:
        {
          if (text.isEmpty) {
            return "Field do not empty.";
          } else if (Validation.validationEmail(text)) {
            return null;
          } else {
            return "The email was entered incorrectly.";
          }
        }

      case ErrorFields.Password:
        {
          if (text.isEmpty) {
            return "Field do not empty.";
          } else if (Validation.validationPassword(text)) {
            return null;
          } else {
            return "The correct password was not entered. The length should be more than 6.";
          }
        }
      case ErrorFields.FullName:
        {
          if(text.isEmpty){
            return "Field do not empty.";
          }
          else{
            return null;
          }
        }
        break;

      case ErrorFields.Confirm:
        {
          if (text.isEmpty) {
            return "Field do not empty.";
          } else if (text == password!) {
            return null;
          } else {
            return "Confirmation is incorrect";
          }
        }
        break;
    }
  }



}

enum ErrorFields { FullName, Email, Password, Confirm }

