import 'package:exd_social_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get.dart';

import '../Widgets/text_button_widget.dart';
import '../Widgets/text_field.dart';
import '../controller/login_&_signup_controller.dart';
import 'Image_picker_profile_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formkey = GlobalKey();
    return GetBuilder<LoginScreenContrroler>(
        init: LoginScreenContrroler(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.cyan,
              title: Text("Login Screen"),
            ),
            body: Form(
              key: formkey,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 20.0, bottom: 8.0),
                    child: Column(
                      children: [
                        TextInputField(
                            label: controller.textEmail,
                            mycontroller: controller.emailController,
                            validator: controller.emailValidator),
                        TextInputField(
                          label: controller.textPass,
                          mycontroller: controller.passwordController,
                          validator: controller.passwordValidator,
                          isobscure: true,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        FlutterPwValidator(
                            width: 350,
                            height: 120,
                            minLength: 8,
                            uppercaseCharCount: 1,
                            numericCharCount: 3,
                            specialCharCount: 1,
                            successColor: Colors.green,
                            failureColor: Colors.red,
                            onSuccess: () {
                              print("MATCHED");
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     new SnackBar(
                              //         content:
                              //         new Text("Password is Matched")));
                              onFail:
                                  () {
                                print("NOT MATCHED");
                              };
                            },
                            controller: controller.passwordController),
                        SizedBox(
                          height: 25,
                        ),
                        TextButtonWidget(btnname: "Login",onpressed: ()async{
                          if(formkey.currentState!.validate()){
                            LoginScreenContrroler.instance.login(emailtext:controller.emailController.text,passwordtext:controller.passwordController.text);
                          }
                        },),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Dont have an account?",
                              style:
                              TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            TextButton(
                                onPressed: () {
                                  Get.to(()=>SignupScreen());
                                },
                                child: Text(
                                  "SignUp",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.cyan,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        });
  }
}
