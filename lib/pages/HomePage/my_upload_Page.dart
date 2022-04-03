import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intagramclone/controllers/my_upload_page_controller.dart';

class MyUploadPage extends StatefulWidget {
  PageController pageController;

  MyUploadPage({Key? key, required this.pageController}) : super(key: key);

  @override
  _MyUploadPageState createState() => _MyUploadPageState();
}

class _MyUploadPageState extends State<MyUploadPage> {
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

//MyUpLoadController
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyUpLoadController>(
        init: MyUpLoadController(),
        builder: (_controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                "Upload",
                style: TextStyle(
                    fontSize: 25, fontFamily: "Billabong", color: Colors.black),
              ),
              actions: [
                IconButton(
                  onPressed: _controller.uploadNewPost,
                  icon: const Icon(Icons.post_add),
                  iconSize: 40,
                  color: const Color.fromRGBO(131, 132, 180, 1),
                )
              ],
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            color: Colors.grey.shade400,
                            child: _controller.image == null
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.add_a_photo,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      _controller.showImageSource(context);
                                    },
                                  )
                                : Container(
                                    child: Stack(
                                      children: [
                                        Image.file(
                                          _controller.image!,
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                          width: double.infinity,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          color: Colors.black12,
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _controller.image = null;
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.highlight_remove),
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: TextField(
                            controller: _controller.captionController,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            minLines: 1,
                            maxLines: 5,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                focusColor: Colors.grey,
                                disabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                //border: InputBorder.none,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade700, width: 2),
                                ),
                                hintText: "Caption",
                                hintStyle: const TextStyle(
                                    color: Colors.black38, fontSize: 17.0)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if (_controller.isLoading)
                  Container(
                    color: Colors.grey.withOpacity(0.3),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        });
  }
}
