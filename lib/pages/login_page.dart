import 'package:app_provider/pages/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                    "Login Page",
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
