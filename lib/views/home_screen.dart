// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/controllers/postcontroller.dart';
import 'package:flutter_task/globals/colors.dart';
import 'package:flutter_task/globals/utils.dart';
import 'package:flutter_task/widgets/drawer.dart';
import 'package:flutter_task/widgets/post_card.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PostController postController = Get.put(PostController());

  @override
  void initState() {
    // TODO: implement initState
    postController.getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.prime,
          title: const Text(
            'Home',
          ),
          centerTitle: true,
        ),
        drawer: MyDrawer(key: _scaffoldKey),
        body: Obx(
          () => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  postController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: MyColors.prime,
                          ),
                        )
                      : Container(
                          child: ElevatedButton(
                            child: Text('Tap'),
                            onPressed: () async {
                              await postController.getPosts();
                              // print(postController.postList![0].postTitle
                              //     .toString());
                            },
                          ),
                        ),
                  Container(
                    child: ElevatedButton(
                      child: Text('dsa'),
                      onPressed: () async {
                        for (int i = 0;
                            i < postController.postList.length;
                            i++) {
                          if (kDebugMode) {
                            print(postController.postList[i].postDescription);
                          }
                        }
                      },
                    ),
                  ),
                  postController.postList.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: postController.postList.length,
                          itemBuilder: (BuildContext context, int _index) =>
                              PostCard(
                                index: _index,
                              ))
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
