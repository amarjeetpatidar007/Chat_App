import 'package:app_provider/models/chat_room_model.dart';
import 'package:app_provider/models/firebase_helper.dart';
import 'package:app_provider/models/user_model.dart';
import 'package:app_provider/pages/chat_room_page.dart';
import 'package:app_provider/pages/login_page.dart';
import 'package:app_provider/pages/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () async{
            await FirebaseAuth.instance.signOut();
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){return const LoginPage();}));
          }, icon: const Icon(Icons.exit_to_app))

        ],
      ),
      body: Center(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .where("participants.${widget.userModel.uid}", isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.active){
                if(snapshot.hasData){
                  QuerySnapshot chatroomSnapshot = snapshot.data as QuerySnapshot;

                  return ListView.builder(
                    itemCount: chatroomSnapshot.docs.length,
                      itemBuilder: (context, index){
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(chatroomSnapshot.docs[index].data() as Map<String, dynamic>);
                      Map<String, dynamic> participants = chatRoomModel.participants!;

                      List<String> participantsKeys = participants.keys.toList();
                      participantsKeys.remove(widget.userModel.uid);

                      return FutureBuilder(
                        future: FirebaseHelper.getUserById(participantsKeys[0]),
                        builder: (context, userData){
                          UserModel targetUser = userData.data as UserModel;
                          if(userData.connectionState == ConnectionState.done){

                            if(userData.data != null){
                              return ListTile(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                    MaterialPageRoute(builder: (context){
                                      return ChatRoomPage(
                                          firebaseUser: widget.firebaseUser,
                                          userModel: widget.userModel,
                                          chatRoomModel: chatRoomModel,
                                          targetUser: targetUser);
                                    })
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(targetUser.profilepic.toString()),
                                  backgroundColor: Colors.grey,
                                ),
                                title: Text(targetUser.fullName.toString()),
                                subtitle: (chatRoomModel.lastMessage.toString() != "") ? Text(chatRoomModel.lastMessage.toString()) : Text('Say Hi',style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary),),
                              );
                            }else{
                              return Container();
                            }
                          }else{
                            return Container();
                          }

                        },
                      );


                      });

                }else if(snapshot.hasError){
                  return const Center(
                    child: Text('Error Occurred'),
                  );
                }else{
                  return const Center(
                    child: Text('No Chats Found!'),
                  );
                }

              }else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchPage(
                firebaseUser: widget.firebaseUser, userModel: widget.userModel);
          }));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
