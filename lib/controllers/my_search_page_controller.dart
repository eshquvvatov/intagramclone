import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intagramclone/model/user_model.dart';
import 'package:intagramclone/service/data_service.dart';

class MySearchController extends GetxController{
  List<User> user = [];
  bool isLoading = false;
  TextEditingController controller = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    apiSearchUsers("");
  }
  void search()async{
    FirebaseFirestore instance = FirebaseFirestore.instance;
    var querySnapshot1 = await instance.collection("users").snapshots().length;
    if(querySnapshot1 !=0){
      apiSearchUsers("");
    }
  }


  void apiSearchUsers(String keyword) {
    isLoading = true;
    update();
    DataService.searchUser(keyword).then((users) => _resSearchUser(users));
  }

  void _resSearchUser(List<User> users) {
    isLoading = false;
    user = users;
    update();
  }

  void _apiFollowUser(User someone) async {
    isLoading = true;
    update();
    await DataService.followUser(someone);
    someone.followed = true;
    isLoading = false;
    update();
    DataService.storePostsToMyFeed(someone);

  }

  void _apiUnFollowUser(User someone) async {
    isLoading = true;
    update();
    await DataService.unFollowUser(someone);
    someone.followed = false;
    isLoading = false;
    update();
    DataService.removePostsFromMyFeed(someone);
  }

  void updateFollow(User user) {
    if (user.followed) {
      _apiUnFollowUser(user);
    } else {
      _apiFollowUser(user);
    }
  }

// Future sentnotification(User someOne) async {
//   print("sentnotification");
//   User name = await DataService.loadUser(null);
//   await HttpService.POST(
//       HttpService.API_SEND,
//       HttpService.paramCreate(
//           someOne.device_token, name.fullName, someOne.fullName));
// }
}