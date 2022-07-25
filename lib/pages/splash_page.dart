import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intagramclone/controllers/sign_in_controller.dart';
import 'package:intagramclone/controllers/splash_controller.dart';
import 'package:intagramclone/pages/sign_in_page.dart';
import 'package:intagramclone/service/pref_service.dart';
import 'package:intagramclone/service/utils.dart';

import 'HomePage/home_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const id = "/splash_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<SplashController>(
            init: SplashController(),
            builder: (_controller) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color.fromRGBO(193, 53, 132, 1),
                      Color.fromRGBO(131, 58, 180, 1),
                    ])),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Expanded(
                          child: Center(
                        child: Text(
                          "Instagram",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 45,
                              fontFamily: "Billabong"),
                        ),
                      )),
                      Text(
                        "All rights reserver",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
              );
            }));
  }
}
