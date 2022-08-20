// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_task/controllers/authcontroller.dart';
import 'package:flutter_task/globals/colors.dart';
import 'package:flutter_task/globals/utils.dart';
import 'package:flutter_task/widgets/button.dart';
import 'package:flutter_task/widgets/textfield.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthController());

  function() {
    // print('object');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(
          () => authController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: MyColors.prime,
                  ),
                )
              : Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: height(context) * 0.03,
                          ),
                          IntlPhoneField(
                            controller: phoneNumberController,
                            //onSaved: (PhoneNumber newValue) => phoneNumber = newValue,
                            onChanged: (value) {
                              if (value.toString().isEmpty) {
                              } else {
                                // countrycode=value.countryCode,

                                // print("full phone number is");
                                // print(value.completeNumber);
                                authController.phoneNumber.value =
                                    value.completeNumber;
                              }
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "";
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
                              // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
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
                            text: 'Login',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                print(authController.phoneNumber.value);

                                authController.password.value =
                                    passwordController.value.text;

                                await authController.checkUserExistsForLogin();
                              }
                            },
                          ),
                          SizedBox(
                            height: height(context) * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account yet?"),
                              GestureDetector(
                                onTap: () => Get.offAllNamed('/signup'),
                                child: Text(
                                  "Sign Up",
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
      ),
    );
  }
}
