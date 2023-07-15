class Message_model{

  String ? text;
  DateTime ? create_msg_time;
  bool ? seen;
  String ? sender;

  Message_model({this.sender, this.text, this.create_msg_time, this.seen});

  Message_model.fromMap(Map<String, dynamic> map){
    text= map['text'];
    create_msg_time= map['create_msg_time'].toDate();
    seen= map['seen'];
    sender= map['sender'];
  }

  Map<String, dynamic> Message_model_toMap(){
    return {
      "text":text,
      "create_msg_time":create_msg_time,
      "seen":seen,
      "sender":sender,
      
    };
  }

}