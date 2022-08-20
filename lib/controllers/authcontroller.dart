import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/globals/routes.dart';
import 'package:flutter_task/globals/utils.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final firstName = ''.obs;
  final lastName = ''.obs;
  final email = ''.obs;
  final phoneNumber = ''.obs;
  final password = ''.obs;
  final firestoreInstance = FirebaseFirestore.instance;
  final isLoading = false.obs;

  Future<void> doesUserExistForSignup() async {
    try {
      isLoading.value = true;
      await firestoreInstance
          .collection('users')
          .where('phonenumber', isEqualTo: phoneNumber.value)
          .get()
          .then((value) async {
        if (value.docs.length > 0) {
          //user already exists with this number
          isLoading.value = false;
          Get.snackbar('Authentication', 'Phone Number already in use',
              backgroundColor: const Color(0xFF221AAF),
              colorText: Colors.white);
          print(value.docs[0].data());
        } else {
          await createAccount();
        }
      });
    } catch (e) {
      print(e.toString());
      isLoading.value = false;
    }
  }

  Future<User?> createAccount() async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      User? user = (await _auth.createUserWithEmailAndPassword(
              email: email.value, password: password.value))
          .user;
      if (user != null) {
        await firestoreInstance
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .set({
          "firstname": firstName.value,
          "lastname": lastName.value,
          "email": email.value,
          "phonenumber": phoneNumber.value,
        });
        isLoading.value = false;
        ;
        Get.offAllNamed(AppRoutes.loginScreen);
        return user;
      } else {
        isLoading.value = false;
        print("Account creation failed");
        return user;
      }
    } on FirebaseAuthException catch (error) {
      isLoading.value = false;
      print("ex");
      print(error.code);
      if (error.code == "email-already-in-use") {
        Get.snackbar('Authentication', 'Email already in use',
            backgroundColor: const Color(0xFF221AAF), colorText: Colors.white);
      }
    }
    return null;
  }

  Future<void> checkUserExistsForLogin() async {
    Map<String, dynamic> userMap;
    try {
      isLoading.value = true;
      await firestoreInstance
          .collection('users')
          .where('phonenumber', isEqualTo: phoneNumber.value)
          .get()
          .then((value) async {
        if (value.docs.length > 0) {
          userMap = value.docs[0].data();

          email.value = userMap['email'];
          await login();
        } else {
          isLoading.value = false;
          ;
          Get.snackbar('Authentication', 'Phone Number not found',
              backgroundColor: const Color(0xFF221AAF),
              colorText: Colors.white);
        }
      });
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.value, password: password.value);

      Get.offAllNamed(AppRoutes.homeScreen);
      isLoading.value = false;
      await storeUserDetailsSharedPreference();
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;

      print(e.code);
      if (e.code == 'weak-password') {
        Get.snackbar("Error", "The password provided is too weak.");
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Error", "Wrong Password");
      }
    } catch (e) {
      print('on catch');
      print(e);
    }
  }

  //signout
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await clearInSharedPref(USERID);
    await clearInSharedPref(EMAIL);
    await clearInSharedPref(TOKEN);
    Get.offAllNamed(AppRoutes.loginScreen);
  }
}
