// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_task/controllers/postcontroller.dart';
import 'package:get/get.dart';

import '../globals/colors.dart';
import '../globals/utils.dart';

class PostCard extends StatefulWidget {
  final int? index;
  const PostCard({Key? key, @required this.index}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final postController = Get.put(PostController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 76, 75, 88),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GetBuilder<PostController>(
            init: postController,
            builder: (_) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      postController.postList[widget.index!].postImageUrl
                          .toString(),
                      width: width(context) - 84,
                      height: width(context) - 84,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    postController.postList[widget.index!].postTitle.toString(),
                    style: const TextStyle(
                        color: MyColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => Text(
                      postController.postList[widget.index!].postDescription
                          .toString(),
                      style: const TextStyle(
                          color: MyColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // postController.text.value =
                          //     'New Description at index ${widget.index.toString()}';
                          // print(postController.text.value);
                          postController
                                  .postList[widget.index!].postDescription =
                              'New Description at index ${widget.index.toString()}';
                          // print(postController
                          //     .postList[widget.index!].postDescription);
                        },
                        child: Icon(
                          Icons.mode_edit_outlined,
                          color: MyColors.white,
                          size: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print(postController
                              .postList[widget.index!].postDescription);
                          postController.postList.removeAt(widget.index!);
                        },
                        child: Icon(
                          Icons.delete_outline,
                          color: MyColors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => Text(
                      postController.text.value,
                      style: TextStyle(color: MyColors.white, fontSize: 20),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
