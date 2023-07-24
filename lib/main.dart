import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lets_chat/app/global/firebase_helper.dart';
import 'package:lets_chat/app/modules/auth/login/view/login_view.dart';
import 'package:lets_chat/app/modules/auth/signUp/view/completeProfilePage.dart';
import 'package:lets_chat/app/modules/auth/signUp/view/sign_up_view.dart';
import 'package:lets_chat/app/modules/home/view/home_view.dart';
import 'package:lets_chat/app/modules/user/model/UserModel.dart';
import 'package:uuid/uuid.dart';


var uuid = Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? currentUser =  FirebaseAuth.instance.currentUser;
  // print(currentUser!.getIdToken());
  if (currentUser != null) {
    UserModel? usermodel =
        await firebase_helper.getCurrentUserModel(currentUser.uid!);

    if (usermodel != null) {
      runApp(MyApp(
        firebaseuser: currentUser,
        usermodel: usermodel,
      ));
    } else {
      runApp(loginapp());
    }
  } else {
    runApp(loginapp());
  }
}

// Already logged in
class MyApp extends StatelessWidget {
  final UserModel usermodel;
  final User firebaseuser;
  MyApp({super.key, required this.firebaseuser, required this.usermodel});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Let\'s Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home_view(firebaseUser: firebaseuser, userModel: usermodel,),
    );
  }
}


// need to login
class loginapp extends StatelessWidget {
  const loginapp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
       [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
       ]
    );
    return GetMaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'Let\'s Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: login_view(),
    );
  }
}
