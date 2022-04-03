import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intagramclone/controllers/my_feed_page_controller.dart';
import 'package:intagramclone/model/post_model.dart';
import 'package:intagramclone/pages/HomePage/user_profel_page.dart';
import 'package:intagramclone/service/utils.dart';

Widget iteamOfPostFeed(MyFeedController controller, context, Post post) {
  return Container(
    //height: 100,
    margin: const EdgeInsets.only(bottom: 2),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
            leading: InkWell(
              onTap: () {
                Get.to(UserProfilePage(), arguments: post.uid);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: post.imageUser != null
                    ? CachedNetworkImage(
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        imageUrl: post.imageUser!,
                        placeholder: (context, url) => const CircleAvatar(
                          backgroundColor: Colors.grey,
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      )
                    : const Image(
                        image: AssetImage("assets/images/user.jpg"),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            trailing: post.isMine
                ? IconButton(
                    icon: const Icon(
                      Icons.more_horiz_rounded,
                      size: 30,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      controller.delete(context, post);
                    },
                  )
                : const SizedBox.shrink(),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.fullName,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                Text(
                  Utils.getMonthDayYear(
                    post.createdDate.toString(),
                  ),
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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                controller.updateLike(post);
              },
              icon: Icon(
                post.isLiked ? Icons.favorite : Icons.favorite_outline,
                color: post.isLiked ? Colors.red : Colors.black,
                size: 27.5,
              ),
            ),
            IconButton(
              onPressed: () async{
               await controller.fileShare(context, post);
              },
              icon: const Icon(
                CupertinoIcons.paperplane_fill,
                color: Colors.black,
                size: 27.5,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(post.caption),
          ],
        ),
        const Divider(),
      ],
    ),
  );
}
