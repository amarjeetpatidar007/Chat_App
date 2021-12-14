import 'dart:developer';

import 'package:app_provider/main.dart';
import 'package:app_provider/models/chat_room_model.dart';
import 'package:app_provider/models/message_model.dart';
import 'package:app_provider/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final User firebaseUser;
  final UserModel userModel;
  final ChatRoomModel chatRoomModel;
  final UserModel targetUser;

  const ChatRoomPage(
      {Key? key,
      required this.firebaseUser,
      required this.userModel,
      required this.chatRoomModel,
      required this.targetUser})
      : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController msgEditingController = TextEditingController();

  void sendMessage() async {
    String msg = msgEditingController.text.trim();
    msgEditingController.clear();

    if (msg != "") {
      MessageModel messageModel = MessageModel(
          messageId: uuid.v1(),
          sender: widget.userModel.uid,
          text: msg,
          createdOn: DateTime.now(),
          seen: false);

      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoomModel.chatRoomId.toString())
          .collection('messages')
          .doc(messageModel.messageId.toString())
          .set(messageModel.toMap());
    }

    widget.chatRoomModel.lastMessage = msg;

    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoomModel.chatRoomId)
        .set(widget.chatRoomModel.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage:
                  NetworkImage(widget.targetUser.profilepic.toString()),
            ),
            const SizedBox(width: 10),
            Text(widget.targetUser.fullName.toString())
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(widget.chatRoomModel.chatRoomId.toString())
                    .collection('messages')
                    .orderBy("createdOn", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot querySnapshot =
                          snapshot.data as QuerySnapshot;
                      return ListView.builder(
                          reverse: true,
                          itemCount: querySnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(
                                querySnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            return Row(
                              mainAxisAlignment: (currentMessage.sender ==
                                      widget.userModel.uid)
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: (currentMessage.sender ==
                                                widget.userModel.uid)
                                            ? Colors.grey
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                        borderRadius:
                                            BorderRadius.circular(6.0)),
                                    child: Text(
                                      currentMessage.text.toString(),
                                      style: TextStyle(
                                          color: (currentMessage.sender ==
                                                  widget.userModel.uid)
                                              ? Colors.white
                                              : Colors.black12),
                                    )),
                              ],
                            );
                          });
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error Occurred!'));
                    } else {
                      return const Center(
                          child: Text('Say Hello to your New Friend'));
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )),
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: msgEditingController,
                      maxLines: null,
                      decoration: const InputDecoration(
                          border: InputBorder.none, labelText: "Enter Message"),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.secondary,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
