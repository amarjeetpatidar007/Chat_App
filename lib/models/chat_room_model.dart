
class ChatRoomModel{
  String? chatRoomId;
  Map<String, dynamic>? participants;
  String? lastMessage;

  ChatRoomModel({this.chatRoomId,this.participants,this.lastMessage});

  ChatRoomModel.fromMap(Map<String, dynamic> map){
    chatRoomId = map['chatRoomId'];
    participants = map['participants'];
    lastMessage = map['lastMessage'];

  }

  Map<String, dynamic> toMap(){
    return {
      'chatRoomId': chatRoomId,
      'participants': participants,
      'lastMessage' : lastMessage
    };
  }
}