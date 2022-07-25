import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intagramclone/pages/HomePage/home_page.dart';
import 'package:intagramclone/service/auth_service.dart';
import 'package:intagramclone/service/deeplink_seervice/leenk.dart';
import 'package:intagramclone/service/pref_service.dart';
import 'package:intagramclone/service/utils.dart';

class SignInPageController extends GetxController{


  String deepLink ="no link";

/// remotaConfig bu biz projectimizni firebase ga ulangan vaqtimizda firebase o'zida settinglarini berib
  /// qo'yamiz va firabase dagi settinglarga most holda bizga bitta String keladi va biz shu kelgan Stringga most
  /// logika yozib quyamiz .Demak umumiy aytganda bizga firebase dan bitta String kelar ekan va biz shunga qarab logika yazamiz
  final remotaConfig=FirebaseRemoteConfig.instance;
  final Map<String,dynamic>availableBackroundColor={
    "red":[Colors.yellow,Colors.blue],
    "yellow":[Colors.red,Colors.purple],
    "blue":[Colors.grey,Colors.green],
    "white":[Colors.black,Colors.blue],
    "black":[Colors.white,Colors.blue],
  };
  var backroiundColor=[ Color.fromRGBO(193, 53, 132, 1),
    Color.fromRGBO(131, 58, 180, 1),];

String? colors;


  Future<void> initConfig()async{
    await remotaConfig.setConfigSettings(RemoteConfigSettings (
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
  }


  void fatchConfig()async{
    await remotaConfig.fetchAndActivate().then((value) => {
      if(remotaConfig.getString("color").isNotEmpty)
        /// getString("color") bu yerdagi color firabaseda hamo birxil bo'lishi kerak .Biz hozi color key bo'yich
        /// firebase dan ottvet so'rayapmiz agar color ikkala tarafda ham birxil bulmasa bizga javob kelmaydi.
    colors =remotaConfig.getString("color")
    },);
    update();
    print("*****************************************************************************************");
    print(colors);
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Utils.initNotification();
    initConfig().then((value) =>fatchConfig() );
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