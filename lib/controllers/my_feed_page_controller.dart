import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart';
import 'package:intagramclone/model/post_model.dart';
import 'package:intagramclone/service/data_service.dart';
import 'package:intagramclone/service/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MyFeedController extends GetxController{
  List<Post> items = [];
  bool isLoading = false;

  Future<void> loadFeed() async {
    isLoading = true;
    update();
    DataService.loadFeeds().then((value) => {setData(value)});
  }

  setData(response) {
    isLoading = false;
    update();
    items = response;
    update();
  }

  void apiPostLike(Post post) async {
    isLoading = true;
    update();
    await DataService.likePost(post, true);
    isLoading = false;
    update();
    post.isLiked = true;
    update();
  }

  void apiUnPostLike(Post post) async {
    isLoading = true;
    update();
    await DataService.likePost(post, false);
    isLoading = false;
    post.isLiked = false;
    update();
  }

  void updateLike(Post post) {
    if (post.isLiked) {
      apiUnPostLike(post);
    } else {
      apiPostLike(post);
    }
  }

  void delete(context,Post post) async {
    bool result = await Utils.dialogCommon(
        context, "Instagram Clone", "Are you want to delete this post", false);
    if (result) {
      isLoading = true;
      update();
      await DataService.removePost(post);
      loadFeed();
      isLoading = false;
      update();
    }
  }
  Future<void> fileShare(context,Post post) async {
    isLoading = true;
    update();
      var response = await get(Uri.parse(post.postImage));
      final documentDirectory = (await getExternalStorageDirectory())?.path;
      File imgFile = File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);
      Share.shareFiles([File('$documentDirectory/flutter.png').path],
          subject: 'Sent from Instagram',
          text: post.caption,);
    //await Share.share(post.postImage);
    isLoading = false;
    update();
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadFeed();
  }

}