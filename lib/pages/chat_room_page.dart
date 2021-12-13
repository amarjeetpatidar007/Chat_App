import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Container()),
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5
              ),
              child: Row(children:  [
                const Flexible(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Enter Message"
                    ),
                  ),
                ),
                IconButton(onPressed: (){}, icon: Icon(Icons.send,color: Theme.of(context).colorScheme.secondary,))
              ],),
            )
          ],
        ),
      ),
    );
  }
}
