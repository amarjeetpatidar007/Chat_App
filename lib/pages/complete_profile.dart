import 'dart:io';

import 'package:app_provider/models/user_model.dart';
import 'package:app_provider/pages/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const CompleteProfile(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  File? imageFile;
  TextEditingController fullNameController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    File? croppedImage = await ImageCropper.cropImage(
        sourcePath: file.path, compressQuality: 25);

    if (croppedImage != null) {
      setState(() {
        imageFile = croppedImage;
      });
    }
  }

  void checkValues() {
    String fullName = fullNameController.text.trim();
    if (fullName.isEmpty || imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill all the necessary Fields')));
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('profilepictures')
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot taskSnapshot = await uploadTask;
    String imageURL = await taskSnapshot.ref.getDownloadURL();
    String fullName = fullNameController.text.trim();

    widget.userModel.fullName = fullName;
    widget.userModel.profilepic = imageURL;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data Uploaded Successfully!'))));
    Navigator.popUntil(context, (route) => route.isFirst);
    await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return HomePage(
          userModel: widget.userModel, firebaseUser: widget.firebaseUser);
    }));
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.width;
    var screenWidth = MediaQuery.of(context).size.width;

    void showPhotoOptions() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Upload Profile Picture'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      selectImage(ImageSource.gallery);
                    },
                    leading: const Icon(Icons.photo_album),
                    title: const Text('Select From Gallery'),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      selectImage(ImageSource.camera);
                    },
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Select From Camera'),
                  )
                ],
              ),
            );
          });
    }

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
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  return showPhotoOptions();
                },
                child: CircleAvatar(
                  radius: screenWidth * 0.2,
                  backgroundImage:
                      (imageFile != null) ? FileImage(imageFile!) : null,
                  child: (imageFile == null)
                      ? Icon(
                          Icons.person,
                          size: screenWidth * 0.2,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
              CupertinoButton(
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  checkValues();
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
