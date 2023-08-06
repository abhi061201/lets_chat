class ChatRoomModel{
  String ? chatRoomId;
  Map<String,dynamic> ?participants;
  String ?lastmsg;
  List<dynamic> ?users;
  DateTime ? last_chat_time;
  ChatRoomModel({this.chatRoomId, this.participants, this.lastmsg,this.last_chat_time, this.users});


  ChatRoomModel.fromMap(Map<String, dynamic> map){
    chatRoomId= map['chatRoomId'];
    participants=map['participants'];
    lastmsg=map['lastmsg'];
    users = map['users'];
    last_chat_time= map['last_chat_time'].toDate();
   
  }

  Map<String , dynamic> toMap(){
    return {
      "chatRoomId":chatRoomId, 
      "participants":participants,
      "lastmsg":lastmsg,
      "last_chat_time":last_chat_time,
      "users":users,
    };
  }

}