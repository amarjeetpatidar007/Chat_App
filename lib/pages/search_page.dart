import 'dart:developer';
import 'dart:ui';

import 'package:app_provider/main.dart';
import 'package:app_provider/models/chat_room_model.dart';
import 'package:app_provider/models/user_model.dart';
import 'package:app_provider/pages/chat_room_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async {
    ChatRoomModel chatRoomModel;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      //Fetch Existing ChatRoom
      log("Already Exists");
      var snapData = querySnapshot.docs[0].data();
      ChatRoomModel existingChatRoom = ChatRoomModel.fromMap(snapData as Map<String, dynamic>);
      chatRoomModel = existingChatRoom;

    } else {
      // Create New ChatRoom
      log("Create New");
      ChatRoomModel newChatRoomModel = ChatRoomModel(
          chatRoomId: uuid.v1(),
          participants: {
            widget.userModel.uid.toString(): true,
            targetUser.uid.toString(): true
          },
          lastMessage: "");

      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(newChatRoomModel.chatRoomId.toString())
          .set(newChatRoomModel.toMap());

      chatRoomModel = newChatRoomModel;
    }

    return chatRoomModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search '),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: "Email Address",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                  child: const Text('Search'),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {});
                  }),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: searchController.text)
                      .where('email', isNotEqualTo: widget.userModel.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;
                        if (dataSnapshot.docs.isNotEmpty) {
                          Map<String, dynamic> userMap = dataSnapshot.docs[0]
                              .data() as Map<String, dynamic>;
                          UserModel searchedUser = UserModel.fromMap(userMap);
                          return ListTile(
                            onTap: () async {
                              ChatRoomModel? chatRoomModel =
                                  await getChatRoomModel(searchedUser);

                              if(chatRoomModel != null){
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return ChatRoomPage(
                                      firebaseUser: widget.firebaseUser,
                                      userModel: widget.userModel,
                                      chatRoomModel: chatRoomModel,
                                      targetUser: searchedUser);
                                }));
                              }

                            },
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(searchedUser.profilepic!),
                            ),
                            title: Text(searchedUser.fullName!),
                            subtitle: Text(searchedUser.email!),
                            trailing: const Icon(Icons.keyboard_arrow_right),
                          );
                        } else {
                          return const Text('No Users Found!');
                        }
                      } else if (snapshot.hasError) {
                        return const Text('Error Occurred');
                      } else {
                        return const Text('No Result Found!');
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
