// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_task/controllers/authcontroller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../globals/utils.dart';
import '../widgets/button.dart';
import '../widgets/textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  final RegExp emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Sign Up',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: height(context) * 0.03,
                  ),
                  MyTextField(
                    controller: firstNameController,
                    textInputType: TextInputType.text,
                    hint: 'First Name',
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Enter First Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height(context) * 0.03,
                  ),
                  MyTextField(
                    controller: lastNameController,
                    textInputType: TextInputType.text,
                    hint: 'Last Name',
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Enter Last Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height(context) * 0.03,
                  ),
                  MyTextField(
                    controller: emailController,
                    textInputType: TextInputType.emailAddress,
                    hint: 'Email',
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Enter Email';
                      } else if (!emailValidatorRegExp.hasMatch(value!)) {
                        return 'Invalid Email Format';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height(context) * 0.03,
                  ),
                  IntlPhoneField(
                    controller: phoneNumberController,
                    onChanged: (value) {
                      if (value.toString().isEmpty) {
                      } else {
                        // countrycode=value.countryCode,

                        // print("full phone number is");
                        // print(value.completeNumber);
                        authController.phoneNumber.value = value.completeNumber;
                      }
                    },
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Enter Phone Number";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      labelText: 'Phone Number',
                      hintText: "Enter your phone number",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      //floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    initialCountryCode: 'PK',
                  ),
                  MyTextField(
                    controller: passwordController,
                    textInputType: TextInputType.text,
                    hint: 'Enter Password',
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Enter Password';
                      } else if (value.toString().length < 8) {
                        return 'Pasword must be of min 8 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height(context) * 0.03,
                  ),
                  Button(
                    text: "Sign Up",
                    onPressed: () async {
                      print('object');
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        authController.firstName.value =
                            firstNameController.value.text;
                        authController.lastName.value =
                            lastNameController.value.text;
                        authController.email.value = emailController.value.text;
                        authController.password.value =
                            passwordController.value.text;

                        await authController.doesUserExistForSignup();
                      } else {}
                    },
                  ),
                  SizedBox(
                    height: height(context) * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? "),
                      GestureDetector(
                        onTap: () => Get.offAllNamed('/login'),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Color(0xff221AAF)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
