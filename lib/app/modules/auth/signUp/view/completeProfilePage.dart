import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_chat/app/image_picker/image_picker.dart';
import 'package:lets_chat/app/modules/auth/signUp/controller/signup_controller.dart';

import '../../../user/model/UserModel.dart';

class completeProfilePage extends StatelessWidget {
  final UserModel? usermodel;
  final User? firebaseuser;
  completeProfilePage({super.key, this.firebaseuser, this.usermodel});

  signup_controller signcontroller = Get.put(signup_controller());
  imagePickerController imagecontroller = Get.put(imagePickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complete Your Profile',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => Center(
                  child: CircleAvatar(
                    backgroundImage: imagecontroller.image_path.value == ''
                        ? null
                        : FileImage(
                            File(
                              imagecontroller.image_path.value.toString(),
                            ),
                          ),
                    radius: 60,
                    child: imagecontroller.image_path.value != ''
                        ? null
                        : Icon(
                            Icons.person,
                          ),
                  ),
                ),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) => customDialog());
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: imagecontroller.image_path == ''
                            ? Text('Add Image')
                            : Text('Edit'),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                    imagecontroller.image_path.value != ''
                        ? InkWell(
                            onTap: () {
                              imagecontroller.reset();
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('Remove'),
                            ),
                          )
                        : Container(),
                  ],
                ).paddingSymmetric(vertical: 8),
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
                  controller: signcontroller.fullNameController,
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    prefixIcon: Icon(Icons.person_2_outlined),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              Obx(
                () => CupertinoButton(
                  onPressed: () {
                    // print('hi');
                    signcontroller.uploadDataToFirestore(
                        usermodel!, firebaseuser!, imagecontroller.Imagefile!);
                  },
                  child: signcontroller.submitbutton.value == false
                      ? Text(
                          'Submit',
                        )
                      : CircularProgressIndicator(),
                ),
              ),
            ],
          ).paddingSymmetric(
            horizontal: 10,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget customDialog() {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: Get.height * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Get.back();
                imagecontroller.getImagefromCamera();
              },
              child: Container(
                width: Get.width,
                height: Get.height * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Center(child: Text('Add from Camera')),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Get.back();
                imagecontroller.getImagefromGallery();
              },
              child: Container(
                width: Get.width,
                height: Get.height * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Center(
                  child: Text(
                    'Add from Gallery',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
