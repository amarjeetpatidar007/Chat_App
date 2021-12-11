import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search '),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20
          ),
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: "Email Address",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(child: const Text('Search'),
                  color: Colors.blue,
                  onPressed: (){}),
              // StreamBuilder();
            ],
          ),
        ),
      ),
    );
  }
}
