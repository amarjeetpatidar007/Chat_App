import 'package:app_provider/models/ui_helper.dart';
import 'package:app_provider/models/user_model.dart';
import 'package:app_provider/pages/complete_profile.dart';
import 'package:app_provider/pages/homepage.dart';
import 'package:app_provider/pages/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email.isEmpty || password.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
    }
    else{
      signIn(email,password);
    }
  }

  void signIn(String email, String password) async{
    UIHelper.showLoadingDialog("Loading ...", context);
    UserCredential? credential;

    try{
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(error){
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message.toString(),),duration: const Duration(seconds: 5),));
    }

    if(credential != null){
      String uid = credential.user!.uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModel userModel = UserModel.fromMap(
        userData.data() as Map<String, dynamic>);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return HomePage(userModel: userModel, firebaseUser: credential!.user!);
      }));

    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const Text(
                    "Login Page",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenHeight * 0.05,),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Enter Email"),
                  ),
                  SizedBox(height: screenHeight * 0.05,),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Enter Password"),
                  ),
                  SizedBox(height: screenHeight * 0.05,),
                  CupertinoButton(
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      checkValues();
                      },
                    child: const Text("Log In"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account? ",style: TextStyle(fontSize: 16),),
          CupertinoButton(child: const Text('Sign Up'), onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context){return const SignUp();})
            );
          } )
        ],
      ),
    );
  }
}
