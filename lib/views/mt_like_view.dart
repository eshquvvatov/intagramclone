import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intagramclone/model/post_model.dart';

import '../controllers/my_like_page_controller.dart';

Widget iteamOfPostLike(MyLikePageController controller, Post post) {
  return Container(
    //height: 100,
    margin: const EdgeInsets.only(bottom: 2),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: const Image(
                image: AssetImage("assets/images/user_image.png"),
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.more_horiz_rounded,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  " UserName",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                Text(
                  "Febuary 2, 2020",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                )
              ],
            )),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          //height: 100,
          child: CachedNetworkImage(
            imageUrl: post.postImage,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  controller.unlikePost(post);
                },
                icon: const Icon(
                  Icons.favorite,
                  size: 30,
                  color: Colors.deepOrange,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.rocket_fill,
                  size: 30,
                )),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: const [
            SizedBox(
              width: 10,
            ),
            Text("Discover more great images on our sponsor's site"),
          ],
        ),
        const Divider(),
      ],
    ),
  );
}