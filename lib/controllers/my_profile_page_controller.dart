import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intagramclone/model/post_model.dart';
import 'package:intagramclone/model/user_model.dart';
import 'package:intagramclone/service/auth_service.dart';
import 'package:intagramclone/service/data_service.dart';
import 'package:intagramclone/service/file_service.dart';
import 'package:intagramclone/service/utils.dart';

class MyProfileController extends GetxController {
  int cout = 1;
  bool isLoading = false;
  File? _image;
  User? user;
  int countPosts = 0;
  List<Post> items = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    apiLoadUser();
    apiLoadPost();
  }

  Future pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    final imageTemporary = File(image.path);
    //final imageTemporary = await  saveImagePermanently(image.path);
    _image = imageTemporary;
    update();
    apiChangePhoto();
  }

  Future<ImageSource?> showImageSource(context) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  child: const Text("Camera"),
                  onPressed: () {
                    pickImage(ImageSource.camera);
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                ),
                CupertinoActionSheetAction(
                  child: const Text("Gallery"),
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                )
              ],
            );
          });
    }
    return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text("Camera"),
                    onTap: () {
                      pickImage(ImageSource.camera);
                      Navigator.of(context).pop(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text("Gallery"),
                    onTap: () {
                      pickImage(ImageSource.gallery);
                      Navigator.of(context).pop(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ));
  }

  void delete(context, Post post) async {
    bool result = await Utils.dialogCommon(
        context, "Instagram Clone", "Are you want to delete this post", false);
    if (result) {
      isLoading = true;
      update();
      await DataService.removePost(post);
      apiLoadPost();
      isLoading = false;
      update();
    }
  }

  Future<void> loadUser() async {
    user = (await DataService.loadUser(null));
  }

  // for load user
  void apiLoadUser() async {
    isLoading = true;
    update();
    DataService.loadUser(null).then((value) {
      return showUserInfo(value);
    });
  }

  void showUserInfo(User user) {
    this.user = user;
    isLoading = false;
    update();
  }

  // for edit user
  void apiChangePhoto() {
    if (_image == null) return;

    isLoading = true;
    update();
    FileService.uploadImage(_image!, FileService.folderUserImg)
        .then((value) => apiUpdateUser(value));
  }

  void apiUpdateUser(String imgUrl) async {
    isLoading = false;
    user!.imageUrl = imgUrl;
    await DataService.updateUser(user!);
    update();
  }

  // for load post
  void apiLoadPost() {
    DataService.loadPosts(null).then((posts) => {resLoadPost(posts)});
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

      // Navigator.pushReplacementNamed(context, );
    }
  }
}
