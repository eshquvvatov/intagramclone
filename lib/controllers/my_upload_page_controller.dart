import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intagramclone/model/post_model.dart';
import 'package:intagramclone/pages/HomePage/home_page.dart';
import 'package:intagramclone/service/data_service.dart';
import 'package:intagramclone/service/file_service.dart';

class MyUpLoadController extends GetxController {
  TextEditingController captionController = TextEditingController();
  File? image;
  bool isLoading = false;

  Future pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    final imageTemporary = File(image.path);
    //final imageTemporary = await  saveImagePermanently(image.path);
    this.image = imageTemporary;
    update();
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
        context:context,
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
  // for post
  void uploadNewPost() {
    String caption = captionController.text.trim().toString();
    if (caption.isEmpty || image == null) return;

    // Send post  to Server

    apiPostImage();
  }

  void apiPostImage() {
    isLoading = true;
    update();

    FileService.uploadImage(image!, FileService.folderPostImg)
        .then((imageUrl) => {
              resPostImage(imageUrl),
            });
  }

  void resPostImage(String imageUrl) {
    String caption = captionController.text.trim().toString();
    Post post = Post(postImage: imageUrl, caption: caption);
    apiStorePost(post);
  }

  void apiStorePost(Post post) async {
    // Post to posts folder
    Post posted = await DataService.storePost(post);
    // Post to feeds folder
    DataService.storeFeed(posted).then((value) => {
          moveToFeed(),
        });
  }

  void moveToFeed() {
    isLoading = false;
    update();
    // Get.affAll (HomePage)  bu hamma Using a widget function instead of a widget fully guarantees that the widget and its controllers will be removed from memory when they are no longer used.
    // Bunda hamma xotirada saqlangan narsalar o'chiriladi va qaytadan homePage ga o'tadi
    Get.offAll(()=>const HomePage());
    //Navigator.pushReplacementNamed(context, HomePage.id);
  }
}
