// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_task/controllers/authcontroller.dart';
import 'package:flutter_task/globals/colors.dart';
import 'package:flutter_task/globals/routes.dart';
import 'package:flutter_task/globals/utils.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: EdgeInsets.only(top: height(context) * 0.1),
          child: Column(
            children: [
              Text(
                'E-Poster',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: height(context) * 0.1,
              ),
              ListTile(
                onTap: () {
                  Get.toNamed(AppRoutes.addPostScreen);
                },
                leading: Icon(
                  Icons.post_add,
                  size: 30,
                  color: MyColors.prime,
                ),
                title: Text(
                  'Create Post',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(
                height: height(context) * 0.02,
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_size_select_actual_outlined,
                  size: 30,
                  color: MyColors.prime,
                ),
                title: Text(
                  'View All Posts',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(
                height: height(context) * 0.02,
              ),
              ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_context) => AlertDialog(
                      title: Text('Are you sure you want to sign out?'),
                      actions: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 33,
                                width: 93,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: MyColors.white,
                                    border: Border.all(color: MyColors.prime)),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    // padding: EdgeInsets.symmetric(horizontal: 8),
                                    primary: Colors.transparent,
                                    onSurface: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    onPrimary: MyColors.prime,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                height: 33,
                                width: 93,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: MyColors.prime,
                                    border: Border.all(color: MyColors.white)),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    // padding: EdgeInsets.symmetric(horizontal: 8),
                                    primary: Colors.transparent,
                                    onSurface: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    onPrimary: MyColors.white,
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await authController.signOut();
                                  },
                                  child: Center(
                                    child: Text(
                                      'Sign Out',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                leading: Icon(
                  Icons.logout,
                  size: 30,
                  color: MyColors.prime,
                ),
                title: Text(
                  'Sign Out',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
