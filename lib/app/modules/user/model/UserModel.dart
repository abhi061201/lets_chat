class UserModel {
  String? uid;
  String? email;
  String? profilePicUrl;
  String? fullName;

  // normal constructor
  UserModel({this.uid, this.fullName, this.email, this.profilePicUrl});

  // serialisation constructor
  // idhr hum map se object bnayenge
  UserModel.fromMap(Map<String, dynamic> map){
    uid= map['uid'];
    email= map['email'];
    profilePicUrl= map['profilePicUrl'];
    fullName= map['fullName'];
  }

  // idhr hum object se mapbnayenge

  Map<String, dynamic> tomap(){
    return {
      "email":email, 
      "fullName":fullName, 
      "uid":uid, 
      "profilePicUrl":profilePicUrl,
    };
  }

  // for json serialisation
  // do object -> map-> json

  // for json deserialisation
  // do json->map->object
}
