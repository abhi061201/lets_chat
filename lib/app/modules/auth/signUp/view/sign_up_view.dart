import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_chat/app/modules/auth/login/view/login_view.dart';
import 'package:lets_chat/app/modules/auth/signUp/controller/signup_controller.dart';
import 'package:lets_chat/app/modules/auth/signUp/view/completeProfilePage.dart';

class signUP_view extends StatelessWidget {
  signUP_view({super.key});
  signup_controller signcontroller = Get.put(signup_controller());
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: Get.height*0.2,),
              Center(
                child: Text(
                  'Lets chat',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: signcontroller.email_controller,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: signcontroller.password_controller,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: signcontroller.confirm_password_controller,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Get.to(completeProfilePage());
                  signcontroller.getvalues_and_check();
                },
                child: Text('SignUp'),
              ),
              SizedBox(
                height: Get.height * 0.3,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'Don\'t have Account ? ',
                    ),
                    TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () => {
                        Get.off(()=>login_view()),
                      },
                      text: 'Login',
                    )
                  ],
                ),
              )
            ],
          ).paddingSymmetric(
            horizontal: 10,
            vertical: 10,
          ),
        ),
      ),
    );
  }
}
