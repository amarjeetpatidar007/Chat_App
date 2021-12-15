
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UIHelper{
  static void showLoadingDialog(String title,BuildContext context){
    AlertDialog alertDialog = AlertDialog(
      content: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 10,
            ),
            Text(title)
          ],
        ),
      ),
    );
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context){
      return alertDialog;
    });
  }

}