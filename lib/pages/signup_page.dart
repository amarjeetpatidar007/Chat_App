import 'package:app_provider/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
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
                    "Sign Up",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenHeight * 0.1,),
                  const TextField(
                    decoration: InputDecoration(labelText: "Enter Email"),
                  ),
                  SizedBox(height: screenHeight * 0.1,),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Enter Password"),
                  ),
                  SizedBox(height: screenHeight * 0.1,),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Confirm Password"),
                  ),
                  SizedBox(height: screenHeight * 0.1,),
                  CupertinoButton(
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {  },
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
          const Text("Already have an Account ",style: TextStyle(fontSize: 16),),
          CupertinoButton(child: const Text('Log In'), onPressed: (){
            Navigator.pop(context);
          } )
        ],
      ),
    );
  }
}
