class ChatRoomModel{
  String ? chatRoomId;
  List<String>? chatRoomParticipants;
  ChatRoomModel({this.chatRoomId, this.chatRoomParticipants});


  ChatRoomModel.toMap(Map<String, dynamic> map){
    chatRoomId= map['chatRoomId'];
    chatRoomParticipants=map['chatRoomParticipants'];
  }

  Map<String , dynamic> toChatRoomMap(){
    return {
      "chatRoomId":chatRoomId, 
      "chatRoomParticipants":chatRoomParticipants,
    };
  }

}