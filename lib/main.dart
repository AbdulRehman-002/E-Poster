import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/globals/routes.dart';
import 'package:flutter_task/views/create_post_screen.dart';
import 'package:flutter_task/views/home_screen.dart';
import 'package:flutter_task/views/login_screen.dart';
import 'package:flutter_task/views/signup_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Task',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        AppRoutes.loginScreen: (_) => const LoginScreen(),
        AppRoutes.signUpScreen: (_) => const SignupScreen(),
        AppRoutes.homeScreen: (_) => const Home(),
        AppRoutes.addPostScreen: (_) => const CreatePostScreen(),
      },
      initialRoute: '/login',
      //home: const MyHomePage(),
    );
  }
}
