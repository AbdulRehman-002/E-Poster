// ignore_for_file: void_checks

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_task/globals/utils.dart';
import 'package:flutter_task/models/post_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../globals/routes.dart';

class PostController extends GetxController {
  final title = ''.obs;
  final description = ''.obs;
  final firestoreInstance = FirebaseFirestore.instance;
  File? imageFile;
  final imageSelected = false.obs;
  dynamic postURL = ''.obs;
  final picker = ImagePicker();
  final downloadUrl = ''.obs;
  FirebaseStorage storage = FirebaseStorage.instance;
  final isLoading = false.obs;
  //List<PostModel>? postList = (List<PostModel>.of([])).obs;
//RxList<PostModel> product = (List<PostModel>.of([])).obs;
  Map<String, dynamic>? result;
  List<PostModel> postList = <PostModel>[].obs;

  final text = 'Abdul Rehman'.obs;

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 20,
        maxHeight: 480,
        maxWidth: 640);

    if (pickedFile == null) {
      print('No image selected.');
      imageSelected.value = false;
    } else {
      imageFile = File(pickedFile.path);
      imageSelected.value = true;
    }
  }

  uploadFile() async {
    try {
      Reference ref =
          storage.ref().child('postimages/${DateTime.now()}${imageFile!.path}');
      UploadTask uploadTask = ref.putFile(imageFile!);

      downloadUrl.value = await (await uploadTask).ref.getDownloadURL();
      print('download url is $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print(e.toString());
      isLoading.value = false;
    }
  }

  Future<dynamic> uploadPost(String title, String description) async {
    String formattedDate =
        DateFormat('EEEE d MMMM y h:mm a').format(DateTime.now());
    try {
      isLoading.value = true;
      await uploadFile();
      firestoreInstance
          .collection('posts')
          .add({
            "postDescription": description,
            'postImageUrl': downloadUrl.value,
            'postTitle': title,
            'time': formattedDate
          })
          .then((value) => {
                print(value.id),
                updateUserFunction(value.id),
              })
          .onError((error, stackTrace) => {
                print(error),
                isLoading.value = false,
              });
    } catch (e) {
      print(e.toString());
      isLoading.value = false;
      return e;
    }
  }

  Future<dynamic> updateUserFunction(String postId) async {
    try {
      String? userId = await getValueInSharedPref(USERID);
      await firestoreInstance.collection("users").doc(userId).update(
        {
          'posts': FieldValue.arrayUnion([postId])
        },
      ).onError((error, stackTrace) {
        isLoading.value = false;
        return error;
      }).then((value) {
        isLoading.value = false;
        print("Updated successfull");
        imageSelected.value = false;
        imageFile = null;
        showToast('Post Uploaded');
        Get.offAllNamed(AppRoutes.homeScreen);

        return value;
      });
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }

  Future<dynamic> getPosts() async {
    try {
      String? userId = await getValueInSharedPref(USERID);
      postList.clear();
      isLoading.value = true;
      await firestoreInstance
          .collection("users")
          .doc(userId)
          .get()
          .onError((error, stackTrace) {
        isLoading.value = false;
        return error as dynamic;
      }).then((value) async {
        result = value.data();
        // print(result!['posts']);
        await getPostDetails(result!['posts']);

        // return value;
      });
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }

  Future<dynamic> getPostDetails(List _postList) async {
    try {
      Map<String, dynamic>? a;
      for (int i = 0; i < _postList.length; i++) {
        await firestoreInstance
            .collection('posts')
            .doc(_postList[i])
            .get()
            .onError((error, stackTrace) {
          isLoading.value = false;
          return error as dynamic;
        }).then((value) {
          a = value.data();
          print(a!['postDescription']);
          PostModel pm = PostModel(
              postId: _postList[i],
              postImageUrl: a!['postImageUrl'],
              postDescription: a!['postDescription'],
              time: a!['time'],
              postTitle: a!['postTitle']);

          postList.add(pm);
          //return value.data() as QuerySnapshot;
        });
      }
      //print(postList![1].postTitle);

      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;
      return error as dynamic;
    }
  }

  Future<dynamic> deletePost(int postListIndex) async {
    try {
      String postId = postList[postListIndex].postId.toString();
      String? userId = await getValueInSharedPref(USERID);
      await firestoreInstance.collection('users').doc(userId).update({
        'posts': FieldValue.arrayRemove([postId])
      }).onError((error, stackTrace) {
        print(error);
        return error as dynamic;
      }).then((value) async {
        await firestoreInstance
            .collection('posts')
            .doc(postId)
            .delete()
            .onError((error, stackTrace) {
          print(error);
        }).then((value) {
          postList.removeAt(postListIndex);
        });
        // return 'a' as dynamic;
      });
    } catch (error) {
      return error as dynamic;
    }
  }
}
