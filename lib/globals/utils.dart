// ignore_for_file: constant_identifier_names, non_constant_identifier_names, prefer_const_declarations

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'colors.dart';

final String FIRSTNAME = 'firstName';
final String LASTNAME = 'lastName';
final String USERID = 'userId';
final String EMAIL = 'email';
final String TOKEN = 'token';
const String INTERNETDICONNECTIONTEXT = 'Check Your Internet Connection';

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

showToast(String message) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: MyColors.prime,
    textColor: Colors.white,
    fontSize: 20,
  );
}

storeUserDetailsSharedPreference() async {
  var user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    print(user);
    String userid = user.uid;
    print("after login user name is " + user.email.toString());

    print("after login user id for shared preference ------>" + userid);
    await storeInSharedPref(USERID, userid);
    //await storeInSharedPref(FIRSTNAME, user.firstname.toString());

    await storeInSharedPref(TOKEN, user.refreshToken.toString());
  }
}

double width(context) {
  return MediaQuery.of(context).size.width;
}

double height(context) {
  return MediaQuery.of(context).size.height;
}

//store in shared preferences

Future storeInSharedPref(String keyName, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(keyName, value);
}

//getting value from share pref providing [key name]
Future<String?> getValueInSharedPref(String keyName) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(keyName);
}

/// Clear object in Shared Pref
Future clearInSharedPref(String keyName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(keyName);
}

void navigateAndRemove(BuildContext context, String to) {
  Navigator.of(context).pushNamedAndRemoveUntil(
    to,
    (route) => false,
  );
}
