class ChatRoomModel{
  String ? chatRoomId;
  Map<String,dynamic> ?participants;
  String ?lastmsg;
  ChatRoomModel({this.chatRoomId, this.participants, this.lastmsg});


  ChatRoomModel.fromMap(Map<String, dynamic> map){
    chatRoomId= map['chatRoomId'];
    participants=map['participants'];
    lastmsg=map['lastmsg'];
  }

  Map<String , dynamic> toMap(){
    return {
      "chatRoomId":chatRoomId, 
      "participants":participants,
      "lastmsg":lastmsg,
    };
  }

}