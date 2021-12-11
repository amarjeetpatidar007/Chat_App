import 'package:app_provider/models/firebase_helper.dart';
import 'package:app_provider/pages/complete_profile.dart';
import 'package:app_provider/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'models/user_model.dart';
import 'pages/homepage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentUser = FirebaseAuth.instance.currentUser;

  if(currentUser != null){
    UserModel? userData = await FirebaseHelper.getUserById(currentUser.uid);
    if(userData != null){
      runApp(UserLoggedIn(firebaseUser: currentUser, userModel: userData));
    }else{
      runApp(const MyApp());
    }

  }else{
    runApp(const MyApp());
  }
}

class UserLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const UserLoggedIn({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(firebaseUser: firebaseUser, userModel: userModel,),
      theme: ThemeData(
          primaryColor: Colors.indigo
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
      theme: ThemeData(
        primaryColor: Colors.indigo
      ),
    );
  }
}
