class UserModel {
  final String token;
  final String username;

  UserModel({required this.token, required this.username});

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      token: json['token'] ?? '',
      username: json['username'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'username': username,
    };
  }
}
