import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intagramclone/model/post_model.dart';
import 'package:intagramclone/model/user_model.dart';
import 'package:intagramclone/service/auth_service.dart';
import 'package:intagramclone/service/data_service.dart';
import 'package:intagramclone/service/deeplink_seervice/leenk.dart';
import 'package:intagramclone/service/utils.dart';

class UserProfileController extends GetxController{
  int cout = 1;
  bool isLoading = false;
  String userUid= Get.arguments;
  User? user;
  int countPosts=0;
  List<Post> items = [];
  String deepLink="";




  final remotaConfig=FirebaseRemoteConfig.instance;
  final Map<String,dynamic>availableBackroundColor={
    "red":Colors.red,
    "yellow":Colors.yellow,
    "blue":Colors.blue,
    "white":Colors.white,
    "black":Colors.black,
  };
  String backroiundColor="white";




  Future<void> initConfig()async{
    await remotaConfig.setConfigSettings(RemoteConfigSettings (
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
  }


  void fatchConfig()async{
    await remotaConfig.fetchAndActivate().then((value) => {
      backroiundColor =remotaConfig.getString("color").isNotEmpty?remotaConfig.getString("color"):
          "white",
    },);
    update();
    print("*****************************************************************************************");
    print(backroiundColor);
  }
  Future<void> loadUser(userUid)async{
    user= (await DataService.loadUser(userUid));
  }
  // for load user
  void apiLoadUser(userUid) async {
    isLoading = true;
    update();
    DataService.loadUser(userUid ).then((value)  {

      return showUserInfo(value);
    });
  }

  void showUserInfo(User user) {
    this.user = user;
    isLoading = false;
    update();

  }

  String reverse(String s){
    var sb = StringBuffer();
    for(var i =s.length-1 ; i>= 0 ; i--){
      sb.writeCharCode(s.codeUnitAt(i));
    }
    return sb.toString();
  }

  // for edit user



  // for load post
  void apiLoadPost(userUid) {
    DataService.loadPosts(userUid).then((posts) => {
      resLoadPost(posts)
    });
  }

  void resLoadPost(List<Post> posts) {
    items = posts;
    countPosts = posts.length;
    update();
  }
  void SignOut(context) async {
    bool result = await Utils.dialogCommon(
        context, "Instagram Clone", "Are you want logOut", false);
    if (result) {
      AuthService.signOutUser(context);
      // update();
      // Navigator.pushReplacementNamed(context, );
    }
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    apiLoadUser(userUid);
    apiLoadPost(userUid);
    initConfig().then((value) => fatchConfig());
    LinkService.retrieveDynamicLink().then((value) => {
      /// logika
      if(value !=null){
        print(value),
        deepLink = value.toString()
        // need to save data locally
      }
      else{
        print(value),
        deepLink="No Link"
      }
    });
  }
}