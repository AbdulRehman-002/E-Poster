import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_task/controllers/postcontroller.dart';
import 'package:flutter_task/globals/utils.dart';
import 'package:flutter_task/widgets/button.dart';
import 'package:flutter_task/widgets/textfield.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../globals/colors.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final postController = Get.put(PostController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.prime,
          title: const Text(
            'Add Post',
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Obx(
            () => postController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: MyColors.prime,
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          postController.imageSelected.value
                              ? Container(
                                  width: width(context) * 0.5,
                                  height: 200,
                                  child: Image.file(
                                    postController.imageFile!,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Button(
                                  text: 'Select Image',
                                  onPressed: () async {
                                    await postController.pickImage();
                                  }),
                          SizedBox(
                            height: height(context) * 0.01,
                          ),
                          postController.imageSelected.value
                              ? GestureDetector(
                                  onTap: () {
                                    postController.imageSelected.value = false;
                                    postController.imageFile = null;
                                    if (postController.imageFile == null) {
                                      print('path is null');
                                    }
                                  },
                                  child: const Text(
                                    'Remove photo',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ))
                              : Container(),
                          MyTextField(
                            controller: titleController,
                            hint: 'Title',
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Enter Title';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height(context) * 0.01,
                          ),
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 5,
                            minLines: 1,
                            decoration:
                                const InputDecoration(hintText: 'Description'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Description';
                              }
                            },
                          ),
                          SizedBox(
                            height: height(context) * 0.03,
                          ),
                          Button(
                            text: 'Done',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                if (postController.imageSelected.isFalse) {
                                  showToast('Choose Image');
                                } else {
                                  bool _isNetworkAvalaible =
                                      await isNetworkAvailable();
                                  if (_isNetworkAvalaible) {
                                    print('Done');
                                    await postController.uploadPost(
                                        titleController.value.text,
                                        descriptionController.value.text);
                                    titleController.clear();
                                    descriptionController.clear();
                                  } else {
                                    showToast(INTERNETDICONNECTIONTEXT);
                                  }
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
