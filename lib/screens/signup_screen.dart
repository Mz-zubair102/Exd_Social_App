import 'package:exd_social_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get.dart';
import '../Widgets/text_field.dart';
import '../controller/login_&_signup_controller.dart';
import 'Test Screens/firebase_screen.dart';
import 'Image_picker_profile_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import '../Widgets/text_button_widget.dart';

class SignupScreen extends StatelessWidget {

  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formkey = GlobalKey();

    LoginScreenContrroler instance = Get.find();
    return GetBuilder<LoginScreenContrroler>(
        init: LoginScreenContrroler(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.cyan,
              title: Text("SignUP Screen"),
            ),
            body: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextInputField(
                          label: _.textUser,
                          mycontroller:_.userController,
                          validator: _.userValidator),
                      TextInputField(
                          label: _.textEmail,
                          mycontroller: _.emailsignupController,
                          validator: _.emailValidator),
                      // TextInputField(
                      //     label: _.labelphoneText,
                      //     mycontroller: _.phonecontroller,
                      //     validator: _.validatephone),
                      // TextInputField(
                      //     label: _.labelemailtext,
                      //     mycontroller: _.emailsignupcontroller,
                      //     validator: _.validateemail),
                      TextInputField(
                        label: _.textPass,
                        mycontroller: _.passworsignupdController,
                        validator: _.passwordValidator,
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
                            ScaffoldMessenger.of(context).showSnackBar(
                                new SnackBar(
                                    content:
                                    new Text("Password is Matched")));
                            onFail:
                                () {
                              print("NOT MATCHED");
                            };
                          },
                          controller: _.passworsignupdController),
                      SizedBox(
                        height: 25,
                      ),
                            TextButtonWidget(btnname: "Signup",onpressed: ()async{
                              if(_formkey.currentState!.validate()){
                                await LoginScreenContrroler.signUpUser(email: _.emailsignupController.text, password: _.passworsignupdController.text, fullname: _.userController.text)
                                    .then((value) {
                                      Get.to(()=>HomeScreen());
                                      Get.defaultDialog(title:"Status",content: Text("Successfull SignUp") );
                                }).onError((error, stackTrace) {
                                  Get.defaultDialog(title:"Status",content: Text(error.toString()) );
                                });

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
                            "Alredy have an account?",
                            style:
                            TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          TextButton(
                              onPressed: () {
                                Get.to(()=>LoginScreen());
                              },
                              child: Text(
                                "Login",
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
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        });
  }
}
