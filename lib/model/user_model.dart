class User {
  String? uid;
  late String fullName;
  late String email;
  late String password;
  String? imageUrl;
  bool followed = false;
  int followers_count = 0;
  int following_count = 0;
  String device_id = "";
  String device_type = "";
  String device_token = "";

  User(
      {this.uid,
      required this.fullName,
      required this.email,
      required this.password,
      });

  User.fromJson(Map<String,dynamic>json){
    uid=json["uid"];
    email=json["email"];
    fullName=json["fullName"];
    password=json["password"];
    imageUrl=json["imageUrl"];
    followed=json["followed"];
    followers_count=json["followers_count"];
    following_count=json["following_count"];
    device_id = json['device_id']??"";
    device_type = json['device_type']??"";
    device_token = json['device_token']??"";
  }

  Map<String,dynamic> toJson(){
    return{
      "uid":uid,
      "fullName":fullName,
      "password":password,
      "imageUrl":imageUrl,
      "followed":followed,
      "followers_count":followers_count,
      "following_count":following_count,
      "email":email,
      'device_id': device_id,
      'device_type': device_type,
      'device_token': device_token,
    };
  }
  @override
  bool operator ==(Object other) {
    return other is User && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
