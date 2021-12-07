import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CompleteProfile extends StatefulWidget {
  const CompleteProfile({Key? key}) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Complete Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            children: [

              const SizedBox(height: 20,),
              CupertinoButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: (){},
                child: const CircleAvatar(

                  radius: 30,
                  child: Icon(Icons.person,size: 60,),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                ),
              ),
              CupertinoButton(
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  Navigator.push(
                      context,
                    MaterialPageRoute(builder: (context){return const CompleteProfile();})
                  );
                },
                child: const Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
